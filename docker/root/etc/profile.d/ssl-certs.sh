# Source custom SSL certificate environment if configured
if [[ -f /config/.ssl_env ]]; then
    source /config/.ssl_env
fi
