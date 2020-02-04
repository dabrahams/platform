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

//==============================================================================
/// Platform
/// The collection of compute resources available to the application
/// on the machine where the process is being run.
public class Platform<Service>: ComputePlatform
    where Service: ComputeService
{
    // properties
    public var logInfo: LogInfo
    public let id: Int
    public let name: String
    public var service: Service
    
    //--------------------------------------------------------------------------
    @inlinable
    public init(id: Int = 0) {
        self.id = id
        self.name = "platform:\(id)"
        // create the log
        logInfo = LogInfo(logWriter: Log(isStatic: true), logLevel: .error,
                          namePath: name, nestingLevel: 0)
        
        // create the service
        self.service = Service(parent: logInfo, id: 0)
    }
}

