//
//  VKAppDelegate.m
//  Poster
//
//  Created by Alyssa Ross on 25/09/2013.
//  Copyright (c) 2013 Alyssa Ross. All rights reserved.
//

#import "VKRequest.h"
#import "VKAppDelegate.h"

@interface VKAppDelegate ()

@property (nonatomic, strong) NSEvent *statusItemActionEvent;

@end

@implementation VKAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    self.statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"statusicon"];
    self.statusItem.highlightMode = YES; // make it go blue when you click

    // single click
    self.statusItem.action = @selector(statusItemClick:);
}

- (VKPanelController *)panelController
{
    if (!_panelController) {
        _panelController = [[VKPanelController alloc] initWithDelegate:self];
    }
    return _panelController;
}

- (NSPoint)topCenterPointForPanelController:(VKPanelController *)panelController
{
    return self.statusItemActionEvent.window.frame.origin;
}

- (void)statusItemClick:(id)sender
{
    if ([NSApp currentEvent].modifierFlags & NSDeviceIndependentModifierFlagsMask) {
        [self togglePanel:sender];
    } else {
        [self repeatLastRequest:sender];
    }
}

- (void)togglePanel:(id)sender
{
    self.statusItemActionEvent = [NSApp currentEvent];
    [self.panelController togglePanel];
}

- (void)repeatLastRequest:(id)sender
{
    [[VKRequest lastRequest] sendRequestWithCompletion:^(NSString *responseOrErrorDescription, BOOL success) {
        [self.panelController setResponseText:responseOrErrorDescription successful:success];
    }];
}

@end
