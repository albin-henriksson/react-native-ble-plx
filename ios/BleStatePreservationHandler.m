#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <React/RCTEventEmitter.h>

@implementation BleStatePreservationHandler

- (instancetype)initWithEventEmitter:(RCTEventEmitter *)eventEmitter {
    self = [super init];
    if (self) {
        self.eventEmitter = eventEmitter; // Use self.propertyName
        self.disconnectedDevices = [NSMutableArray new]; // Use self.propertyName
        NSDictionary *options = @{CBCentralManagerOptionRestoreIdentifierKey: @"BleStatePreservationHandler"};
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options]; // Use self.propertyName
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
