//
//  VKPanelController.h
//  Poster
//
//  Created by Alyssa Ross on 25/09/2013.
//  Copyright (c) 2013 Alyssa Ross. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VKRequest;
@protocol VKPanelControllerDelegate;

@interface VKPanelController : NSWindowController <NSWindowDelegate>

@property (nonatomic, weak) IBOutlet NSPopUpButton *methodPopUp;
@property (nonatomic, weak) IBOutlet NSTextField *URLField;
@property (nonatomic, weak) IBOutlet NSTextField *responseField;

@property (nonatomic, strong) VKRequest *request;

@property (nonatomic, weak) id <VKPanelControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id <VKPanelControllerDelegate>)delegate;

- (void)togglePanel;
- (IBAction)request:(id)sender;
- (IBAction)clear:(id)sender;

- (void)setResponseText:(NSString *)text successful:(BOOL)successful;

@end

@protocol VKPanelControllerDelegate

- (NSPoint)topCenterPointForPanelController:(VKPanelController *)panelController;

@end
