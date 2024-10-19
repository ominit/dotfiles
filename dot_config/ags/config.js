function Bar(monitor =  0) {
  const label = Widget.Label({
    label: 'hello'
  })

  return Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ['top'],
    child: label,
  })
}

App.config({ windows: [
  Bar(0),
  Bar(1),
]})
