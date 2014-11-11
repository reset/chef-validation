# validation-cookbook

Perform validation on your node's attributes from a Cookbook's attribute metadata definitions.

## Supported Platforms

* Ubuntu 12.04 / 14.04
* CentOS

## Usage

Add the validation cookbook to your cookbook's metadata

```
name             "my_app"
maintainer       "Jamie Winsor"
maintainer_email "jamie@vialstudios.com"
license          "MIT"
description      "Installs/Configures my_app"
long_description "Installs/Configures my_app"
version          "0.1.0"

depends "validation"
```

Now leverage the `validate_attributes` definition provided by the validation cookbook by placing it in one of your cookbook's recipes.

```
validate_attributes "my_app"
```

### Compile time validation

By default, attribute validation will occur at convergence time but this can be switched to compile time by setting an attribute on the `validate_attributes` definition.

```
validate_attributes "my_app" do
  mode :compile
end
```

### Convergence time validation

You can also explicitly validate at convergence

```
validate_attributes "my_app" do
  mode :converge
end
```

However, this is not necessary since `:converge` is the default mode.

### Filtering validation

The name parameter of the `validate_attributes` definition is also the `cookbook` parameter. Setting this to the name of a cookbook will cause attribute validations to only be run for the metadata of that cookbook for the resource the definition creates. You can have multiple `validate_attributes` definitions within your resource chain or you can validate against all of your run context's loaded cookbooks.

```
validate_attributes "all"
```

> Note: I swear to fucking god - if one of you makes a cookbook called "all" and puts that shit on the community site I will drink myself into the grave faster than I already am.

## License and Authors

Author:: Jamie Winsor (<jamie@vialstudios.com>)
