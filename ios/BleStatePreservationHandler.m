#import "BleStatePreservationHandler.h"

@implementation BleStatePreservationHandler

- (instancetype)initWithEventEmitter:(RCTEventEmitter *)eventEmitter {
    self = [super init];
    if (self) {
        self.eventEmitter = eventEmitter;
        NSDictionary *options = @{CBCentralManagerOptionRestoreIdentifierKey: @"BleStatePreservationHandler"};
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    }
    return self;
}

// CBCentralManagerDelegate - State Restoration
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    // Emit event to React Native
    if (self.eventEmitter) {
        [self.eventEmitter sendEventWithName:@"StateRestored"
                                         body:@{@"restoredPeripherals": peripherals}];
    }
}

// CBCentralManagerDelegate - Disconnection
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSString *deviceIdentifier = peripheral.identifier.UUIDString;

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
