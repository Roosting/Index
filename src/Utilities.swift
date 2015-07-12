import Foundation

func printAndExit(message: String) {
  println(message)
  exit(1)
}

public func readFile(path: String) -> String {
  let url = NSURL(fileURLWithPath: path)!
  var error: NSError?

  let contents = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)

  if contents == nil {
    let errorString = error!.localizedDescription
    printAndExit("Error reading file: \(errorString)")
  }
  return contents! as String
}
