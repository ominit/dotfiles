# Desktop

makai runs a Sway session on its KVM display at 1280x720 with a tabbed layout, so only the focused window is on screen. Your shell's `WAYLAND_DISPLAY` and `SWAYSOCK` point at that session.

- Start GUI programs with `swaymsg exec <command>` so they run inside the session instead of under the t3code service.
- Use the `cua-driver` tools for desktop apps and the `chrome-devtools` tools for the agent browser (Helium, CDP on 127.0.0.1:9222). A window must be focused before cua-driver can capture its pixels.
- The desktop and browser are shared. Only one agent should control them at a time.
- If a CAPTCHA or login challenge appears, stop and ask the user to solve it through the KVM.
