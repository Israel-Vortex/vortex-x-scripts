export default function handler(req, res) {
    // 1. Desactivar almacenamiento en caché
    res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');

    const userAgent = req.headers['user-agent'] || '';

    // 2. Detección de navegadores web
    const isBrowser = /Mozilla|Chrome|Safari|Edge|Firefox|Opera|Android|iPhone/i.test(userAgent);

    if (isBrowser) {
        return res.redirect(302, '/index.html');
    }

    // 3. Validación de clave de autenticación
    const clientKey = req.headers['x-vortex-key'];
    if (clientKey !== "VORTEX_SECRET_PASS_2026") {
        return res.status(401).send('-- [VORTEX] Acceso Denegado');
    }

    // 4. Código fuente de Luau
    const vortexScript = `
        print("Vortex Software cargado con éxito")
        -- Tu script real aquí
    `;

    res.setHeader('Content-Type', 'text/plain; charset=utf-8');
    return res.status(200).send(vortexScript);
}
