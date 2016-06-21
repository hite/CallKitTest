//
//  CallDirectoryHandler.m
//  BlockU Extension
//
//  Created by hite on 6/21/16.
//  Copyright © 2016 hite. All rights reserved.
//

#import "CallDirectoryHandler.h"

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    NSArray<NSString *> *phoneNumbersToBlock = [self retrievePhoneNumbersToBlock];
    if (!phoneNumbersToBlock) {
        NSLog(@"Unable to retrieve phone numbers to block");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    for (NSString *phoneNumber in phoneNumbersToBlock) {
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }
    
    NSArray<NSString *> *phoneNumbersToIdentify = [self retrievePhoneNumbersToIdentify];
    NSArray<NSString *> *phoneNumberIdentificationLabels = [self retrievePhoneNumberIdentificationLabels];
    if (!phoneNumbersToIdentify || !phoneNumberIdentificationLabels) {
        NSLog(@"Unable to retrieve phone numbers to identify and their labels");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    for (NSUInteger i = 0; i < phoneNumbersToIdentify.count; i += 1) {
        NSString *phoneNumber = phoneNumbersToIdentify[i];
        NSString *label = phoneNumberIdentificationLabels[i];
        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

- (NSArray<NSString *> *)retrievePhoneNumbersToBlock {
    // retrieve list of phone numbers to block
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.app.blockU"];
    NSArray<NSString *> *list = [myDefaults objectForKey:@"blockList"];
    return list;
}

- (NSArray<NSString *> *)retrievePhoneNumbersToIdentify {
    // retrieve list of phone numbers to identify
    return @[];
}

- (NSArray<NSString *> *)retrievePhoneNumberIdentificationLabels {
    // retrieve list of phone numbers identification labels
    return @[];
}

@end
