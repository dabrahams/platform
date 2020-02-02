//******************************************************************************
// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation

//==============================================================================
/// CudaService
/// The collection of compute resources available to the application
/// on the machine where the process is being run.
public struct Sharding<Service>: ServiceOptimizer
    where Service: ComputeService
{
    // properties
    public var accelerators: [CpuDevice]
    public var cpu: CpuDevice
    public var id: Int
    public let logInfo: LogInfo
    public var name: String
    public let service: Service
    
    //--------------------------------------------------------------------------
    public init(parent logInfo: LogInfo, id: Int) {
        self.name = "Sharding"
        self.logInfo = logInfo.child(name)
        self.cpu = CpuDevice(parent: self.logInfo, id: 0)
        self.id = id
        self.accelerators = []
        self.service = Service(parent: self.logInfo, id: self.id)
    }
}
