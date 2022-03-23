param ($NiceLogFolder='D:\Program Files\Nice Systems\Logs', $BackupFolder='d:\Backup\Logs')

enum LogLevel 
{
    Debug
    Info
	Warning
	Error
}

class  BaseLogger
{
	[void] Log([LogLevel]$Level, [string]$Message) 
	{
		write-host "Method not implemented" 
    }
}

class ScreenLogger:BaseLogger 
{
    
	[void] Log([LogLevel]$Level, [string]$Message) 
	{
		$date=Get-Date -Format "yyyy-MM-dd HH:mm:ss";
		write-host "$date $Message" 
    }
}

class  BaseFolderProvider 
{
    [string]$Brand
}

class FolderProvider:BaseFolderProvider 
{
    
}

class  BaseProcessor
{
	
	[void] ProcessFolder([string]$slot) 
	{
		write-host "Method not implemented" 
    }
}

class Processor:BaseProcessor 
{
	[BaseLogger] $logger

	Processor([BaseLogger]$Logger)
	{
        $this.logger = $Logger
    }
	
    [void] ProcessFolder([string]$slot) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Method overrided" )
    }
}

$logger=[ScreenLogger]::new()
$processor = [Processor]::new($logger)

$processor.ProcessFolder($NiceLogFolder);
