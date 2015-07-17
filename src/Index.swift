import Foundation
import MessagePack

class Index {
  
  private let formatter: NSDateFormatter = NSDateFormatter()

  init() {
    formatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss'Z'"
  }

  func packPackages(packages: [Package]) {
    let path = getOutputName()

    if !fileManager.createFileAtPath(path, contents: nil, attributes: nil) {
      printAndExit("Failed to create index file '\(path)'")
    }

    let file = NSFileHandle(forWritingAtPath: getOutputName())!

    let header = "Roost Index Version 1\n"
    file.writeData(header.dataUsingEncoding(NSUTF8StringEncoding)!)

    var dictionary = [MessagePackValue : MessagePackValue]()

    for package in packages {
      let key = MessagePackValue.String(package.name)
      let value = packedPackage(package)

      dictionary[key] = value
    }

    let packed = MessagePack.pack(.Map(dictionary))

    file.writeData(packed)
  }

  private func packedPackage(package: Package) -> MessagePackValue {
    return MessagePackValue.Map([
      .String("name")     : .String(package.name),
      .String("version")  : .String(package.version.description),
      .String("versions") : packPackageVersions(package.versions),
    ])
  }

  /**
    Convert Array of Version structs into a MessagePackValue.Array of
    MessagePackValue.Map instances.
  */
  private func packPackageVersions(versions: [Version]) -> MessagePackValue {
    let versionsValues = versions.map { (v) in
      return MessagePackValue.Map([
        .String("version")     : .String(v.version.description),
        .String("description") : .String(v.description),
      ])
    }

    return MessagePackValue.Array(versionsValues)
  }

  /**
    Timestamped name of the file to which to write the packed index.
  */
  private func getOutputName() -> String {
    let date = formatter.stringFromDate(NSDate())

    return "Index-\(date).bin"
  }

}
