//
//  VKPanelController.m
//  Poster
//
//  Created by Alyssa Ross on 25/09/2013.
//  Copyright (c) 2013 Alyssa Ross. All rights reserved.
//

#import "AFNetworking.h"
#import "VKRequest.h"
#import "VKPanelController.h"

//#define NO_CLOSE YES

@interface VKPanelController ()

@property (nonatomic, copy) NSMutableArray *parametersArray;

@end

@implementation VKPanelController

- (id)init
{
    return [super initWithWindowNibName:@"VKPanel" owner:self];
}

- (instancetype)initWithDelegate:(id<VKPanelControllerDelegate>)delegate
{
    self = [self init];
    self.delegate = delegate;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    VKRequest *lastRequest = [VKRequest lastRequest];
    if (!lastRequest) return;

    [self.methodPopUp selectItemWithTitle:lastRequest.method];
    self.URLField.stringValue = [lastRequest.URL absoluteString];
    self.parameters = lastRequest.parameters;
}

- (void)togglePanel
{
    if (self.window.isKeyWindow) {
        [self.window resignKeyWindow];
    } else {
        [self.window becomeKeyWindow];
    }
}

- (void)showWindow:(id)sender
{
    NSRect frame = self.window.frame;
    frame.origin = [self.delegate topCenterPointForPanelController:self];
    frame.origin.y -= frame.size.height;

    // make sure it's not overflowing.
    frame.origin.x = MAX(0, MIN([NSScreen mainScreen].frame.size.width, frame.origin.x + frame.size.width) - frame.size.width);

    [self.window setFrame:frame display:NO];


    [super showWindow:sender];

    [self.window setLevel:NSPopUpMenuWindowLevel];

//    [self.URLField becomeFirstResponder];
//    [self.window makeFirstResponder:self.URLField];
}

- (NSMutableArray *)parametersArray
{
    if (!_parametersArray) {
        _parametersArray = [NSMutableArray new];
    }
    return _parametersArray;
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    for (NSDictionary *parameter in self.parametersArray) {
        parameters[parameter[@"name"]] = parameter[@"value"];
    }
    return [parameters copy];
}

- (void)setParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [NSMutableArray new];
    for (NSString *name in parameters) {
        [parametersArray addObject:@{@"name": name, @"value": parameters[name]}];
    }
    self.parametersArray = parametersArray;
}

- (void)request:(id)sender
{
    VKRequest *request = [[VKRequest alloc] initWithMethod:[self.methodPopUp titleOfSelectedItem]
                                                       URL:[NSURL URLWithString:self.URLField.stringValue]
                                                parameters:self.parameters];

    [request sendRequestWithCompletion:^(NSString *responseOrErrorDescription, BOOL success) {
        [self setResponseText:responseOrErrorDescription successful:success];
    }];
}

- (void)setResponseText:(NSString *)text successful:(BOOL)successful
{
    self.responseField.textColor = successful ? [NSColor blackColor] : [NSColor redColor];
    self.responseField.stringValue = text;
}

- (void)clear:(id)sender
{
    self.responseField.stringValue = @"";
    self.URLField.stringValue = @"";
    self.parameters = nil;
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    [self showWindow:self];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
#ifndef NO_CLOSE
    [self.window orderOut:self];
#endif
}

@end
