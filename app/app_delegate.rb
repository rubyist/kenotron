class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    @designerController = KenKenDesignerController.alloc.initWithNibName(nil, bundle:nil)
    
    @window.rootViewController = @designerController
    @window.makeKeyAndVisible
    
    true
  end
end
