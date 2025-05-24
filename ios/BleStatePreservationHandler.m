#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <React/RCTEventEmitter.h>

@interface BleStatePreservationHandler : NSObject <CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray<NSString *> *disconnectedDevices;
@property (nonatomic, weak) RCTEventEmitter *eventEmitter;
@end

@implementation BleStatePreservationHandler

- (instancetype)initWithEventEmitter:(RCTEventEmitter *)eventEmitter {
    self = [super init];
    if (self) {
        _eventEmitter = eventEmitter;
        _disconnectedDevices = [NSMutableArray new];
        NSDictionary *options = @{CBCentralManagerOptionRestoreIdentifierKey: @"BleStatePreservationHandler"};
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    }
    return self;
}

// CBCentralManagerDelegate - State Restoration
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    for (CBPeripheral *peripheral in peripherals) {
        [self.disconnectedDevices addObject:peripheral.identifier.UUIDString];
    }
}

// CBCentralManagerDelegate - Disconnection
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSString *deviceIdentifier = peripheral.identifier.UUIDString;
    [self.disconnectedDevices addObject:deviceIdentifier];

    // Emit event to React Native
    if (self.eventEmitter) {
        [self.eventEmitter sendEventWithName:@"DeviceDisconnected"
                                         body:@{@"deviceId": deviceIdentifier, @"error": error ? error.localizedDescription : [NSNull null]}];
    }
}

// CBCentralManagerDelegate - Required Method
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // Handle state updates if needed
}

@end
