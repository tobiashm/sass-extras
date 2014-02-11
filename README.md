# Sass::Extras

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'sass-extras'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sass-extras

## Usage

TODO: Write usage instructions here

### `contrast-color`

```SCSS
span {
  color: contrast-color($text-color, $alternative-background);
}
```

### `inline-color-image`

```SCSS
a {
  background: url(inline-color-image(rgba(102, 54, 32, 0.5)));
}
```

### SVG gradients

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

```SCSS
a {
  background-color: yuva(10%, 0, 0, 0.5); /* #191919, 50% alpha */
}
```

## Contributing

1. Fork it ( http://github.com/tobiashm/sass-extras/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
