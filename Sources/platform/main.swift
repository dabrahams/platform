
let platform = Platform<CpuService>()
platform.logWriter.level = .diagnostic
platform.logWriter.categories = [.queueAlloc]
//print(platform.service.name)
//print(platform.service.cpu.name)
//print(platform.service.cpu.queues.count)
print(platform.service.cpu.queues[0].logInfo.namePath)

print("end")
