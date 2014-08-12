# CSS

[![Install in CSS Hat](http://img.shields.io/badge/install-to%20CSS%20Hat-blue.svg)](http://addons.csshat.com/?install=csshat/language-css)

This is a template for [CSS Hat 2](https://csshat.com/) that generates CSS. This is the only template that ships with CSS Hat and is used for generating preview.

## Settings

### Vendor Prefixes

With this option on, some values will be prefixed to work in various browser. TODO: document when

### Inherit Font Styles

If you have a layer with more text styles, template will output just first complete style with all properties and the others will be just diffs (useful if they are childs of the main element - for example `<strong>` in `<p>`)

```css
font-family: "Helvetica";
font-size: 12px;

font-weight: bold;
```

### Selector

It will add curly braces and selector to the output

```css
.layer-name {
  color: #000000;
}
```

<!--### SelectorTextStyle

You can choose text style
-->

### Selector Type

We try to autogenerate a selector from layer name. You can choose which type it should be

| Option | Example |
| ------ | ------- |
| class | `.button` |
| id | `#button` |
| element | button`` |

### Color Type

Choose your preferred color syntax. 

> Note that if you select hex, sometimes it may actually output an `rgba`, because hex has no option to express alpha.

### Show Text Snippet

If you have text layer with more styles (various text sizes, colors, …), it will show you snippet of text in comment, so you know which rule relates to which part of content
