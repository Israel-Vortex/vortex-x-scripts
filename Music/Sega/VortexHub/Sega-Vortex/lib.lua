--[[
	sega-vortex/music lib.lua — Ayudantes compartidos de interfaz de usuario / entrada / HTTP / iconos.
	Genérico (sin lógica de jugador), reutilizable por otros scripts de ryshub.
]]

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

Biblioteca local = {}

-- ================= Conexiones =================

-- Conexiones globales (no del árbol de la interfaz de usuario) creadas a través de Lib.track; una nueva ejecución de llamadas
-- Lib.cleanup() para desconectarlos todos.
conexiones locales = {}

función Lib.track(conn)
	tabla.insertar(conexiones, conn)
	conexión de retorno
fin

función Lib.cleanup()
	para _, conn en ipairs(connections) hacer
		pcall(función()
			conexión:Desconectar()
		fin)
	fin
	tabla.borrar(conexiones)
fin

-- ================= HTTP =================

-- Obtiene una URL intentando acceder a todas las API HTTP que el ejecutor pueda exponer.
función Lib.fetch(url)
	para _, getter en ipairs({ game.HttpGetAsync, game.HttpGet }) hacer
		local ok, res = pcall(getter, juego, url)
		Si está bien y type(res) == "string" y res ~= "" entonces
			retorno res
		fin
	fin
	local ok, res = pcall(function()
		devolver HttpService:GetAsync(url)
	fin)
	devolver ok y res o nil
fin

-- Descarga y ejecuta un módulo Lua, devolviendo su resultado (o nil).
función Lib.fetchModule(url)
	local src = Lib.fetch(url)
	si no src entonces
		devolver cero
	fin
	local ok, resultado = pcall(función()
		devolver loadstring(src)()
	fin)
	devolver ok y resultado o nil
fin

-- ================= Ayudantes de instancia =================

-- Constructor de instancias declarativo; `Parent` se aplica al final.
función Lib.create(className, props)
	local inst = Instancia.new(className)
	para clave, valor en pares(propiedades) hacer
		Si la clave es ~= "Padre" entonces
			inst[clave] = valor
		fin
	fin
	inst.Parent = props.Parent
	devolver inst
fin

función Lib.corner(parent, radiusPx)
	return Lib.create("UICorner", {
		CornerRadius = radiusPx y UDim.new(0, radiusPx) o UDim.new(1, 0),
		Padre = padre,
	})
fin

función Lib.padding(padre, arriba, abajo, izquierda, derecha)
	return Lib.create("UIPadding", {
		PaddingTop = UDim.new(0, top o 0),
		RellenoInferior = UDim.new(0, inferior o 0),
		RellenoIzquierdo = UDim.new(0, izquierda o 0),
		PaddingRight = UDim.new(0, right o 0),
		Padre = padre,
	})
fin

-- ================= Entrada =================

Lib.TAP_THRESHOLD = 6 -- píxeles de movimiento antes de que una pulsación cuente como arrastre

función Lib.isPress(input)
	devolver input.UserInputType == Enum.UserInputType.MouseButton1
		o input.UserInputType == Enum.UserInputType.Touch
fin

función Lib.isMove(input)
	devolver input.UserInputType == Enum.UserInputType.MouseMovement
		o input.UserInputType == Enum.UserInputType.Touch
fin

-- Hace que `target` siga los arrastres del puntero que comienzan en `handle`. Si `onTap` es
-- dado que, en cambio, un comunicado de prensa sin acción real lo activa.
función Lib.makeDraggable(handle, target, onTap)
	arrastre local = falso
	local movido = falso
	prensa localEn, inicioPos

	manejador.InputBegan:Connect(function(input)
		Si Lib.isPress(input) entonces
			arrastrando = verdadero
			movido = falso
			presionarEn = entrada.Posición
			posiciónInicio = posiciónDestino
		fin
	fin)

	Lib.track(UserInputService.InputChanged:Connect(function(input)
		si se arrastra y Lib.isMove(input) entonces
			delta local = input.Position - pressAt
			Si delta.Magnitude > Lib.TAP_THRESHOLD entonces
				movido = verdadero
			fin
			target.Position = UDim2.new(
				escala.startPos.X, desplazamiento.startPos.X + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		fin
	fin))

	Lib.track(UserInputService.InputEnded:Connect(function(input)
		si se arrastra y Lib.isPress(input) entonces
			arrastrando = falso
			si está activado y no se ha movido entonces
				onTap()
			fin
		fin
	fin))
fin

-- Funcionamiento del control deslizante: al pulsar `hit` se inicia el arrastre y `apply(position)`.
-- Se ejecuta con cada movimiento del puntero hasta que se suelta. Devuelve una sonda isDragging().
función Lib.makeSlider(hit, apply)
	arrastre local = falso

	hit.InputBegan:Connect(function(input)
		Si Lib.isPress(input) entonces
			arrastrando = verdadero
			aplicar(entrada.Posición)
		fin
	fin)

	Lib.track(UserInputService.InputChanged:Connect(function(input)
		si se arrastra y Lib.isMove(input) entonces
			aplicar(entrada.Posición)
		fin
	fin))

	Lib.track(UserInputService.InputEnded:Connect(function(input)
		Si Lib.isPress(input) entonces
			arrastrando = falso
		fin
	fin))

	devolver función()
		regresar arrastrando
	fin
fin

-- ================= Iconos =================

-- Sistema de iconos respaldado por el módulo de iconos de Footagesus, descargado bajo demanda y
-- almacenado en caché (compartido con otros scripts a través de _G.Lucide). Cada icono tiene un
-- Texto de ejemplo como alternativa cuando el módulo no se puede cargar.
Iconos locales = {
	url = nil,
	paquete = "lúcido",
	módulo = nulo,
}
Lib.icons = Iconos

función Icons.configure(url, pack)
	Iconos.url = url
	Icons.pack = pack o Icons.pack
fin

función local getModule()
	si Icons.module entonces
		devolver Icons.module
	fin
	si type(_G) == "table" y _G.Lucide entonces
		Iconos.módulo = _G.Lucide
		devolver Icons.module
	fin
	si no Icons.url entonces
		devolver cero
	fin
	local mod = Lib.fetchModule(Icons.url)
	si mod entonces
		Iconos.módulo = mod
		_G.Lucide = mod
	fin
	devolver Icons.module
fin

-- Resuelve un icono a { Image, ImageRectOffset, ImageRectSize } o nil.
-- Siempre solicita el paquete explícito para que no dependa del tipo predeterminado.
-- otro script podría haberlo configurado.
función local readAsset(nombre)
	local lucide = getModule()
	Si no es lúcido o no tiene nombre, entonces
		devolver cero
	fin

	datos locales
	para _, fnName en ipairs({ "Icon2", "Icon" }) hacer
		si type(lucide[fnName]) == "función" entonces
			local ok, res = pcall(lucide[fnName], name, Icons.pack, true)
			Si está bien y res entonces
				datos = res
				romper
			fin
		fin
	fin

	si type(data) == "string" entonces
		return { Image = data, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero }
	elseif type(data) == "table" y data[1] y data[2] entonces
		imagen local = datos[1]
		si type(image) == "número" entonces
			imagen = "rbxassetid://" .. tostring(imagen)
		fin
		devolver {
			Imagen = imagen,
			ImageRectOffset = data[2].ImageRectPosition o data[2].ImageRectOffset o Vector2.zero,
			ImageRectSize = data[2].ImageRectSize o Vector2.zero,
		}
	fin

	conjunto local = lucide.Icons y lucide.Icons[Icons.pack]
	entrada local = conjunto y conjunto.Iconos y conjunto.Iconos[nombre]
	si entrada entonces
		imagen local = (set.Spritesheets y set.Spritesheets[tostring(entrada.Imagen)]) o entrada.Imagen
		si type(image) == "número" entonces
			imagen = "rbxassetid://" .. tostring(imagen)
		fin
		devolver {
			Imagen = imagen,
			ImageRectOffset = entrada.ImageRectPosition o entrada.ImageRectOffset o Vector2.zero,
			ImageRectSize = entrada.ImageRectSize o Vector2.zero,
		}
	fin

	devolver cero
fin

función Iconos.apply(imageObject, nombre)
	activo local = leerActivo(nombre)
	Si no se trata de un activo o tipo(activo.Imagen) ~= "cadena" o activo.Imagen == "" entonces
		imageObject.Image = ""
		devolver falso
	fin
	imageObject.Image = asset.Image
	Si typeof(asset.ImageRectOffset) == "Vector2" entonces
		imageObject.ImageRectOffset = asset.ImageRectOffset
	fin
	Si typeof(asset.ImageRectSize) == "Vector2" entonces
		imageObject.ImageRectSize = asset.ImageRectSize
	fin
	devolver verdadero
fin

-- Visualización de iconos (imagen + texto como alternativa) centrada en `parent`.
-- `set(name, glyph)` intercambia el icono, `tint(color)` cambia el color de ambas capas.
función Icons.createIcon(parent, size, color, fallbackTextSize)
	local img = Lib.create("ImageLabel", {
		Nombre = "Icono",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Posición = UDim2.new(0.5, 0, 0.5, 0),
		Tamaño = UDim2.fromOffset(tamaño, tamaño),
		Transparencia de fondo = 1,
		ImageColor3 = color,
		Padre = padre,
	})
	local fb = Lib.create("TextLabel", {
		Nombre = "Respaldo",
		Tamaño = UDim2.new(1, 0, 1, 0),
		Transparencia de fondo = 1,
		Texto = "",
		TextColor3 = color,
		Fuente = Enum.Font.GothamBold,
		TextSize = fallbackTextSize o math.floor(size * 0.9),
		Visible = falso,
		Padre = padre,
	})

	ctl local = {}
	función ctl.set(iconName, glyph)
		si glifo entonces
			fb.Text = glifo
		fin
		local ok = Icons.apply(img, iconName)
		img.Visible = ok
		fb.Visible = no está bien
	fin
	función ctl.tint(c)
		img.ImageColor3 = c
		fb.TextColor3 = c
	fin
	devolver ctl
fin

devolver Lib