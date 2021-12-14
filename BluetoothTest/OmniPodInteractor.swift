//
//  File.swift
//  BluetoothTest
//
//  Created by Bill Gestrich on 12/12/21.
//

import Foundation
import AsyncBluetooth
import CoreBluetooth

struct OmnipodInteractor {
    
    let advertisementService = CBUUID.init(string: "00004024-0000-1000-8000-00805f9b34fb")
    let commandCharacteristicUUID = CBUUID.init(string: "1A7E2441-E3ED-4464-8B7E-751E03D0DC5F")
    let dataCharacteristicUUID = CBUUID.init(string: "1A7E2442-E3ED-4464-8B7E-751E03D0DC5F")
    
    func run() async {
        let centralManager = CentralManager()

        do {
            try await centralManager.waitUntilReady()

            let scanDataStream = try await centralManager.scanForPeripherals(withServices: [advertisementService])
            
            guard let peripheral = await scanDataStream.first(where: {$0 != nil})?.peripheral else {
                print("Could not find peripheral")
                return
            }
            
            await centralManager.stopScan()
            
            try await centralManager.connect(peripheral, options: nil)
            
            try await peripheral.discoverServices(nil)
            
            guard let service = peripheral.discoveredServices?.first else {
                print("Could not find service.")
                return
            }
            
            try await peripheral.discoverCharacteristics(nil, for: service)
            
            guard let commandCharacteristic = service.discoveredCharacteristics?.first(where: {$0.uuid.uuidString == commandCharacteristicUUID.uuidString }) else {
                print("could not find characteristics")
                return
            }

            
            guard let dataCharacteristic = service.discoveredCharacteristics?.first(where: {$0.uuid.uuidString == dataCharacteristicUUID.uuidString }) else {
                print("could not find characteristics")
                return
            }

            
            

            //2021-12-13 19:37:05.739 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on CMD: 06010400001092
            try await peripheral.writeCommand(PodCommand.helloCommand(), characteristic: commandCharacteristic, writeType: .withoutResponse)

            //2021-12-13 19:37:05.772 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.readyToRead():119]: Enabling indications for CMD
            try await peripheral.setNotifyValue(true, for: commandCharacteristic)
            
            //2021-12-13 19:37:05.820 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.readyToRead():119]: Enabling indications for DATA
            try await peripheral.setNotifyValue(true, for: dataCharacteristic)
            
            //2021-12-13 19:37:07.722 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on CMD: 00
            try await peripheral.writeCommand(PodCommand.rtsCommand(), characteristic: commandCharacteristic, writeType: .withResponse)
            let _ = try await peripheral.readCommand(characteristic: commandCharacteristic)
            
            //2021-12-13 19:37:07.851 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 0002545710030100038000001092fffffffe5350
            try await peripheral.writeHex("0002545710030100038000001092fffffffe5350", characteristic: dataCharacteristic, writeType: .withResponse)
            
            //2021-12-13 19:37:07.895 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 01313d0004000010912c5350323d000bffc32dbd
            try await peripheral.writeHex("01313d0004000010912c5350323d000bffc32dbd", characteristic: dataCharacteristic, writeType: .withResponse)
            
            //2021-12-13 19:37:07.937 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 02072989314008030e0100008a00000000000000
            try await peripheral.writeHex("02072989314008030e0100008a00000000000000", characteristic: dataCharacteristic, writeType: .withResponse)
            
            //2021-12-13 19:37:08.003 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on CMD: 00
            let _ = try await peripheral.readCommand(characteristic: commandCharacteristic)
            try await peripheral.writeCommand(PodCommand.rtsCommand(), characteristic: commandCharacteristic, writeType: .withResponse)
            let _ = try await peripheral.readCommand(characteristic: commandCharacteristic)
            
            //2021-12-13 19:37:08.090 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 000354571003020006e000001092fffffffe5350
            try await peripheral.writeHex("000354571003020006e000001092fffffffe5350", characteristic: dataCharacteristic, writeType: .withResponse)
            
            //2021-12-13 19:37:08.133 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 0153313d00301ac74b2b6da0ef53b2029309bade
            try await peripheral.writeHex("0153313d00301ac74b2b6da0ef53b2029309bade", characteristic: dataCharacteristic, writeType: .withResponse)
            
            //2021-12-13 19:37:08.174 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 02602c83ea43adb68ff8914286e9a3d9a6fb70d8
            try await peripheral.writeHex("02602c83ea43adb68ff8914286e9a3d9a6fb70d8", characteristic: dataCharacteristic, writeType: .withResponse)

            //2021-12-13 19:37:08.211 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 030f91464c72977e0c3f0473a0b3aeb1ab577d15
            try await peripheral.writeHex("030f91464c72977e0c3f0473a0b3aeb1ab577d15", characteristic: dataCharacteristic, writeType: .withResponse)
            
            //2021-12-13 19:37:08.253 17874-18021/info.nightscout.androidaps D/PUMPBTCOMM: [RxCachedThreadScheduler-25]: [BleIO.sendAndConfirmPacket():59]: BleIO: Sending on DATA: 0401830000000000000000000000000000000000
            try await peripheral.writeHex("0401830000000000000000000000000000000000", characteristic: dataCharacteristic, writeType: .withResponse)
            
            
            /*
             .withoutResponse: Peripheral will not write the reponse to the characteristic afterwards.
             .withResponse: Peripheral will write the resposne to the characteristic afterwards.
             */
           
//            let _ = try await peripheral.readCommand(characteristic: commandCharacteristic)
//            let _ = try await peripheral.readCommand(characteristic: commandCharacteristic)
//            let _ = try await peripheral.readCommand(characteristic: commandCharacteristic)
//
            
            let _ = try await peripheral.readCommand(characteristic: commandCharacteristic)
            
        } catch {
            print("Error \(error)")
        }

    }
}


extension Peripheral {
    
    func readCommand(characteristic: Characteristic) async throws -> PodCommand {
        
        try await readValue(for: characteristic)
        
        guard let data = characteristic.value else {
            throw PeripheralError.noReadData
        }
        
        let command = PodCommand(data: data)
        print("Read comand: \(command.commandCode())")
        return command
    }
    
    func writeCommand(_ command: PodCommand, characteristic: Characteristic, writeType: CBCharacteristicWriteType) async throws {
        print("Writing comand: \(command.commandCode())")
        try await writeValue(command.data, for: characteristic, type: writeType)
    }
    
    func writeHex(_ hex: String, characteristic: Characteristic, writeType: CBCharacteristicWriteType) async throws {
        print("Writing data: \(hex)")
        try await writeValue(Data(hexadecimalString: hex)!, for: characteristic, type: writeType)
//        try await readValue(for: characteristic)
//        print("last data = \(characteristic.value?.hexadecimalString)")
    }
    
    enum PeripheralError: Error {
        case noReadData
    }
}



enum PodCommandCode: UInt8 {
    case RTS = 0x00
    case CTS = 0x01
    case NACK = 0x02
    case ABORT = 0x03
    case SUCCESS = 0x04
    case FAIL = 0x05
    case HELLO = 0x06
    case INCORRECT = 0x09
}

struct PodCommand {
    
    let data: Data
    
    init(data: Data){
        assert(PodCommand.isValidCommand(data: data))
        self.data = data
    }
    
    init(hexString: String) {
        self.init(data: Data(hexadecimalString: hexString)!)
    }
    
    func commandCode() -> PodCommandCode {
        return PodCommand.commandCode(data: self.data)!
    }
    
    static func commandCode(data: Data) -> PodCommandCode? {
        let firstBytes = [data[0]]
        let intVal = UInt8(firstBytes.withUnsafeBytes({ ptr in
            ptr.load(as: UInt8.self)
        }))
        
        return PodCommandCode(rawValue: intVal)
    }
            
    static func isValidCommand(data: Data) -> Bool {
        commandCode(data: data) != nil
    }
    
    static func helloCommand() -> PodCommand {
        return PodCommand(data: Data([PodCommandCode.HELLO.rawValue, 0x01, 0x04] + myID())) //"06010400001092"
    }
    
    static func rtsCommand() -> PodCommand {
        return PodCommand(data: Data([PodCommandCode.RTS.rawValue]))
    }
    
    static func myID() -> Data {
        return Data(hexadecimalString: "00001092")!
    }
}
