import Gdk from 'gi://Gdk'
import App from 'resource:///com/github/Aylur/ags/app.js'

import { Bar } from './modules/bar/main.js';

const range = (length, start = 1) => Array.from({ length }, (_, i) => i + start);
function forMonitors(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
    return range(n, 0).map(widget).flat(1);
}

function forMonitorsAsync(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
    return range(n, 0).forEach((n) => widget(n).catch(print));
}

const Windows = () => [

];

App.config({
    windows: Windows().flat(1),
});

forMonitorsAsync(Bar)
