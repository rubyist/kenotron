class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    @designer_controller = KenKenDesignerController.alloc.initWithNibName(nil, bundle:nil)
    
    @window.rootViewController = @designer_controller
    @window.makeKeyAndVisible
    
    true
  end
end
