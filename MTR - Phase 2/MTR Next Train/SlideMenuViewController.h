//
//  SlideMenuViewController.h
//  MTR Next Train
//
//  Created by Jackson on 7/8/14.
//
//

#import <UIKit/UIKit.h>

@interface SlideMenuViewController : UIViewController {


    IBOutlet UILabel *slideMenu_Tittle;
    IBOutlet UILabel *slideTittle_Language;
    IBOutlet UILabel *slideTittle_Update;
    IBOutlet UILabel *slideTittle_Terms;
    IBOutlet UILabel *slideTittle_Tutorial;
    IBOutlet UILabel *slideTittle_CheckUpdate;

    
}

@property (nonatomic, retain) IBOutlet UIButton *slide_Language_button;
@property (nonatomic, retain) IBOutlet UIButton *slide_Update_button;
@property (nonatomic, retain) IBOutlet UIButton *slide_Terms_button;
@property (nonatomic, retain) IBOutlet UIButton *slide_Tutorial_button;
@property (nonatomic, retain) IBOutlet UIButton *slide_CheckUpdate_button;

- (void)setLang;

@end
