#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <React/RCTEventEmitter.h>

@interface BleStatePreservationHandler : NSObject <CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray<NSString *> *disconnectedDevices;
@property (nonatomic, weak) RCTEventEmitter *eventEmitter;

- (instancetype)initWithEventEmitter:(RCTEventEmitter *)eventEmitter;

@end
