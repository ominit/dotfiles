const { Gtk } = imports.gi;
import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import Workspaces from './normal/workspaces.js'

export const Bar = async (monitor = 0) => {
	const label = Widget.Label({
		label: 'hello'
	});

	Utils.interval(1000, () => {
		label.label = Utils.exec('date')
	})

	return Widget.Window({
		monitor,
		name: `bar${monitor}`,
		anchor: ['top', 'left', 'right'],
		exclusivity: 'exclusive',
		visible: true,
		child: label,
	});
}
