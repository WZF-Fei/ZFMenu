# ZFMenu
auto layout menu icon for iPhone or iPad

##How to create ZFMenuItem?

```obj-c

    UIViewController *viewController = [[UIViewController alloc] init];
    ZFMenuItem *menuItem = [ZFMenuItem  initWithTitle:@"item1"
                                            imageName:@"usedes_normal"
                                    selectedImageName:@"usedes_normal"
                                       viewController:viewController];
```