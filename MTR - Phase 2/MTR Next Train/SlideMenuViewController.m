//
//  SlideMenuViewController.m
//  MTR Next Train
//
//  Created by Jackson on 7/8/14.
//
//

#import "SlideMenuViewController.h"
#import "CoreData.h"

@interface SlideMenuViewController ()

@end

@implementation SlideMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLang];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLang
{
    
    [slideMenu_Tittle setText:NSLocalizedString(([NSString stringWithFormat:@"slideMenu_Tittle_%@", [CoreData sharedCoreData].lang]), nil)];
    
    [slideTittle_Language setText:NSLocalizedString(([NSString stringWithFormat:@"slideTittle_Language_%@", [CoreData sharedCoreData].lang]), nil)];
    [slideTittle_Update setText:NSLocalizedString(([NSString stringWithFormat:@"slideTittle_Update_%@", [CoreData sharedCoreData].lang]), nil)];
    [slideTittle_Terms setText:NSLocalizedString(([NSString stringWithFormat:@"slideTittle_Terms_%@", [CoreData sharedCoreData].lang]), nil)];
    [slideTittle_Tutorial setText:NSLocalizedString(([NSString stringWithFormat:@"slideTittle_Tutorial_%@", [CoreData sharedCoreData].lang]), nil)];
    [slideTittle_CheckUpdate setText:NSLocalizedString(([NSString stringWithFormat:@"slideTittle_CheckUpdate_%@", [CoreData sharedCoreData].lang]), nil)];
    
    slideMenu_Tittle.font = [UIFont boldSystemFontOfSize:16.0f];
    slideTittle_Language.font = [UIFont boldSystemFontOfSize:16.0f];
    slideTittle_Update.font = [UIFont boldSystemFontOfSize:16.0f];
    slideTittle_Terms.font = [UIFont boldSystemFontOfSize:16.0f];
    slideTittle_Tutorial.font = [UIFont boldSystemFontOfSize:16.0f];
    slideTittle_CheckUpdate.font = [UIFont boldSystemFontOfSize:16.0f];

}

@end
