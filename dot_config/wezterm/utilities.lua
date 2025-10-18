local M = {}

-- Detect OS type: "windows", "macos", "linux", or "wsl"
function M.detect_os()
    local raw_os_name, raw_arch = '', ''

    -- Check environment variables first (works on Windows)
    if package.config:sub(1, 1) == '\\' then
        return 'windows'
    end

    -- Try to get OS name from uname
    local f = io.popen 'uname -s 2>/dev/null'
    if f then
        raw_os_name = f:read '*l' or ''
        f:close()
    end

    raw_os_name = raw_os_name:lower()

    if raw_os_name:match 'linux' then
        -- Check for WSL (Windows Subsystem for Linux)
        local f = io.popen 'uname -r 2>/dev/null'
        local kernel = f and f:read '*l' or ''
        if f then
            f:close()
        end
        kernel = kernel:lower()

        if kernel:match 'microsoft' or kernel:match 'wsl' then
            return 'wsl'
        else
            return 'linux'
        end
    elseif raw_os_name:match 'darwin' then
        return 'macos'
    elseif raw_os_name:match 'windows' or raw_os_name:match 'mingw' or raw_os_name:match 'cygwin' then
        return 'windows'
    else
        return 'unknown'
    end
end

return M
