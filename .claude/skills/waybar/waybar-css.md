# SKILL.md — CSS Theming in Waybar via GTK3

Waybar’s theming layer is an implementation of GTK3’s CSS engine. This means Waybar’s appearance can be altered entirely through a stylesheet (`style.css`) using valid GTK CSS syntax and properties. This file outlines the complete extent of that support.

***

## Files and Load Order

Waybar loads the first existing stylesheet from:


You can reference system defaults or other files using `@import url("file:///path/to/other.css");`.[1]

***

## Supported Selectors and Structure

Waybar modules and elements are rendered as GTK widgets and exposed through CSS nodes. Each module has an `id` prefixed with a hash and classes applied automatically:
- `#clock`, `#workspaces`, `#tray`, `#window`, `#custom-*`
- `.module`, `.focused`, `.urgent`, `.hover`

GTK CSS supports:
- `:hover`, `:checked`, `:disabled`, `:backdrop`, `:focus`
- Attribute-based selectors and inheritance (`.parent .child {}`)
- Group selectors (`.workspaces button, #tray {}`)

***

## Waybar-Specific Features

Hover and cursor styling can be applied globally or per module:

```css
#clock:hover { background-color: #ffffff; }
#custom-launcher { cursor: pointer; }
```

Cursor type values correspond to [Gdk cursor types](https://docs.gtk.org/gdk3/enum.CursorType.html). Setting `"cursor": false` disables interaction feedback.[1]

***

## GTK3-Compatible CSS Properties

Waybar supports all CSS properties accepted by GTK3, including all `-gtk-*` vendor extensions. Key property families below derive from the GTK 3.0 specification.[2]

### Color and Opacity

- `color`
- `background-color`
- `opacity`
- `-gtk-icon-palette`
- `-gtk-icon-effect: none | highlight | dim`

### Font

- `font-family`
- `font-size`
- `font-style`
- `font-weight`
- `font-variant`
- `font-stretch`
- `-gtk-dpi`

### Box Model

- `margin-{top,right,bottom,left}`
- `padding-{top,right,bottom,left}`
- `min-width`, `min-height`

### Border and Radius

- `border-{top,right,bottom,left}-width`
- `border-{top,right,bottom,left}-color`
- `border-radius`
- `border-style`
- `outline`, `outline-width`, `outline-color`, `outline-offset`
- `-gtk-outline-radius`

### Background

- `background-image`
- `background-size`
- `background-repeat`
- `background-position`
- `background-clip`, `background-origin`
- `background-blend-mode`
- `box-shadow`

### Transitions and Animations

- `transition`, `transition-delay`, `transition-duration`
- `animation`, `animation-delay`, `animation-duration`, `animation-timing-function`

GTK3 supports CSS3 transitions and keyframe animations applied to CSS-driven visual changes.[2]

***

## GTK Extensions (`-gtk-` prefixed)

GTK adds unique rendering-specific properties:

- `-gtk-icon-source`, `-gtk-icon-transform`, `-gtk-icon-shadow`
- `-gtk-outline-radius`
- `-gtk-key-bindings`
- `-gtk-secondary-caret-color`
- `-gtk-icon-style`, `-gtk-icon-theme`

These determine how symbolic icons, outlines, and keyboard focus are drawn.[2]

***

## Useful Notes

- GTK CSS units: `px`, `pt`, `em`, `rem`, `%`, `deg`, `s`, `ms`
- Arithmetic via `calc()`
- Supports `inherit`, `initial`, `unset` keywords
- Color variables and imports (`@define-color` and `@import`) may be used for dynamic theming
- Waybar respects GTK’s theme context — e.g., foreground `color`, system font scaling, and roundness values

***

## Example

Example Waybar stylesheet demonstrating GTK-compatible CSS:

```css
@define-color accent @theme_selected_bg_color;

* {
  font-family: "JetBrains Mono";
  font-size: 11pt;
}

#workspaces button {
  background-color: transparent;
  border: none;
  color: @theme_fg_color;
  padding: 0 6px;
}

#workspaces button:hover {
  background-color: mix(@theme_base_color, @accent, 0.1);
}

#clock {
  color: @accent;
  padding: 0 10px;
  border-radius: 6px;
  transition: background-color 0.2s ease;
}
```

This uses only GTK3 CSS primitives fully supported through Waybar’s style engine.

[1](https://man.archlinux.org/man/extra/waybar/waybar-styles.5.en)
[2](https://docs.gtk.org/gtk3/css-properties.html)
[...]