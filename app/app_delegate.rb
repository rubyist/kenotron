class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @selectPuzzleController = SelectPuzzleController.alloc.initWithNibName(nil, bundle:nil)

    @window.rootViewController = @selectPuzzleController
    @window.makeKeyAndVisible
    
    true
  end
end
