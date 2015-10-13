import Foundation

func printAndExit(message: Any) {
  print(message)
  exit(1)
}

public func readFile(path: String) -> String! {
  do {
    let url = NSURL(fileURLWithPath: path)
    let contents = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
    return contents as String
  } catch {
    printAndExit("Error reading file: \(error)"); return nil
  }
}
