# Sass::Extras

A collection of miscellaneous SASS extensions. Mostly concerned with colour manipulation.

## Installation

Add this line to your application's Gemfile:

    gem 'sass-extras'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sass-extras

## Usage

Just require this gem in your project, and it will extend the `Sass::Script::Functions` module with a selection of functions that will be available in your `.sass` or `.scss` files.

Notice: All examples are in SCSS syntax.

### Contrast Color

Will adjust a colour so that it conforms to the [WAI](http://www.w3.org/WAI/ER/WD-AERT/#color-contrast) and [WCAG20](http://www.w3.org/TR/WCAG20/#visual-audio-contrast-contrast) recommendations for minimum contrast for text.

```SCSS
span {
  color: contrast-color($text-color, $background-color);
}
```

### Inline Image with a Colour

Generate a data URL for an image of a given colour. Useful for e.g. backgrounds with an alpha channel in browsers that does not support `rgba`.

```SCSS
a {
  background: url(inline-color-image(rgba(102, 54, 32, 0.5)));
}
```

### SVG gradients

Generate data URI for SVG images with either a linear or a radial gradient.

Optional first argument is the colour of the gradient, going from solid to total transparent for the linear and 20% opacity for the radial gradient.

Optional second argument is the height of the generated image.

```SCSS
.scrollbox {
  background-image: radial-gradient-image-data-url(black);
  &:before {
    background-image: linear-gradient-image-data-url(white);
  }
  /* some positioning etc. */
}
```

### YUV color space

Offers two methods for generating colours based on the YUV space: `yuv(y, u, v)` and `yuva(y, u, v, alpha)`.

```SCSS
a {
  background-color: yuva(10%, 0, 0, 0.5); /* #191919, 50% alpha */
}
```

Besides that, a couple of helper functions to adjust brightness based on the YUV colour space, is provided.

```SCSS
set-brightness($color, $amount);
increase-brightness($color, $amount);
reduce-brightness($color, $amount);
add-brightness($color, $amount);
detract-brightness($color, $amount);
```

## Contributing

1. Fork it ( http://github.com/tobiashm/sass-extras/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
