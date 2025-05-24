#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <React/RCTEventEmitter.h>

@interface BleStatePreservationHandler : NSObject <CBCentralManagerDelegate>

- (instancetype)initWithEventEmitter:(RCTEventEmitter *)eventEmitter;

@end
