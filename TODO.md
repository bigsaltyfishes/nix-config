# TODO
## Known issue
1. Cannot launch some native NixOS Application via Steam
* This is caused by `Steam Secure Wrapper`, we need to unset `LD_PRELOADER` and `LD_LIBRARY_PATH` for them.

2. Programs with CAP sets won't start via Steam
* This is a known issue on NixOS (FHS Shell)
* We need a wrapper to let `FHS Enviroment` communicate with `Normal Environment`.

## Solution
Both two issues can be fix via a `wrapper`, it is easy to write such a program for `CLI programs`, but for `GUI Programs`, we need extra effort to forward `X Request` and `Wayland Request`.

1. Server Side (User session)
- [ ] Accept connection from client (localhost-only, create socket at `/run/user/$UID/`), create a **pty** for it.
- [ ] Run program request by client with specific environments (only accept one request)
- [ ] Create `X Forward Server` and `Wayland Forward Server`, let client connect to them and accept request from them at handshake time, once connection established, neccessary envirment will be set by server. (Passive forward method)

2. Client Side 
- [ ] Connect to server that running via current user
- [ ] Send program run request to server
- [ ] Forward `stdin` and `stdout`
- [ ] Connect to forward servers depends on whether `DISPLAY` and `WAYLAND_DISPLAY`.