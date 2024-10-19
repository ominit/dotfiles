const { Gtk } = imports.gi;
import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

export const Bar = async (monitor = 0) => {
    const SideModule = (children) => Widget.Box({
        className: 'bar-sidemodule',
        children: children,
    });
    const normalBarContent = Widget.CenterBox({
        className: 'bar-bg',
        setup: (self) => {
            const styleContext = self.get_style_context();
            const minHeight = styleContext.get_property('min-height', Gtk.StateFlags.NORMAL);
            // execAsync(['bash', '-c', `hyprctl keyword monitor ,addreserved,${minHeight},0,0,0`]).catch(print);
        },
        // startWidget: (await WindowTitle(monitor)),
        centerWidget: Widget.Box({
            className: 'spacing-h-4',
            children: [
                // SideModule([Music()]),
                Widget.Box({
                    homogeneous: true,
                    // children: [await NormalOptionalWorkspaces()],
                }),
                // SideModule([System()]),
            ]
        }),
        // endWidget: Indicators(monitor),
    });
    const focusedBarContent = Widget.CenterBox({
        className: 'bar-bg-focus',
        startWidget: Widget.Box({}),
        centerWidget: Widget.Box({}),
        endWidget: Widget.Box({}),
        // setup: (self) => {
        //     if (!Battery.available) return;
        //     self.toggleClassName('bar-bg-focus-batterylow', Battery.percent <= 70)
        // }
    });
    const nothingContent = Widget.Box({
        className: 'bar-bg-nothing',
    });
    return Widget.Window({
        monitor,
        name: `bar${monitor}`,
        anchor: ['top', 'left', 'right'],
        exclusivity: 'exclusive',
        visible: true,
        child: Widget.Stack({
            homogeneous: false,
            transition: 'slide_up_down',
            children: {
                'focus': focusedBarContent,
                'nothing': nothingContent,
            }
            // setup: (self) => self.hook(currentShellMode, (self) => {
            //     self.shown = currentShellMode.value[monitor];
            // }),
        }),
    });
}
