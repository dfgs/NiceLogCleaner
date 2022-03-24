[cmdletbinding(SupportsShouldProcess)]
param ($NiceLogFolder='D:\Program Files\Nice Systems\Logs', $BackupFolder='d:\Backup\Logs')

enum LogLevel 
{
    Debug = 0
    Info = 1
	Warning = 2
	Error = 3
}

class File
{
	[string] $Name
	[string] $FullName
	[DateTime] $LastWriteTime

	File([string]$Name,[string]$FullName,[DateTime]$LastWriteTime)
	{
		$this.Name=$Name
		$this.FullName=$FullName
		$this.LastWriteTime=$LastWriteTime
	}
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
		$method=(Get-PSCallStack)[1].FunctionName
		switch ( $Level )
		{
			Debug { Write-Host "$date | $Level | $method | $Message" -ForegroundColor DarkGray    }
			Info { Write-Host "$date | $Level | $method | $Message" -ForegroundColor White  }
			Warning { Write-Host "$date | $Level | $method | $Message"-ForegroundColor Yellow   }
			Error { Write-Host "$date | $Level | $method | $Message"-ForegroundColor Red }
		}		 
    }
}
class NullLogger:BaseLogger 
{
    
	[void] Log([LogLevel]$Level, [string]$Message) 
	{
		 
    }
}
class  BaseChildFolderProvider 
{
    [File[]] GetChildFolders([string]$ParentFolder) 
	{
		write-host "Method not implemented" 
		return @()
    }
}

class ChildFolderProvider:BaseChildFolderProvider 
{
	[BaseLogger] $logger

	ChildFolderProvider([BaseLogger]$Logger)
	{
        $this.logger = $Logger
    }

	[File[]] GetChildFolders([string]$ParentFolder) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Entering method" )

		$this.logger.Log( [LogLevel]::Info, "Listing child folders in $ParentFolder" )

		[File[]] $childFolders=Get-ChildItem -Path $ParentFolder -Directory -Force | ForEach-Object {[File]::new($_.Name,$_.FullName,$_.LastWriteTime)}
		foreach ($childFolder in $childFolders)
		{
			$this.logger.Log( [LogLevel]::Debug, "Found folder $($childFolder.Name)" )
		}
		return $childFolders
    }
}
class MockedChildFolderProvider:BaseChildFolderProvider 
{

	MockedChildFolderProvider()
	{
    }

	[File[]] GetChildFolders([string]$ParentFolder) 
	{
		if ($ParentFolder -eq "D:\Program Files\Nice Systems\Logs")
		{
			$childFolders=@(
				[File]::new("Component1","D:\Program Files\Nice Systems\Logs\Component1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
				[File]::new("Component2","D:\Program Files\Nice Systems\Logs\Component2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
				[File]::new("Component3","D:\Program Files\Nice Systems\Logs\Component3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
				[File]::new("Component4","D:\Program Files\Nice Systems\Logs\Component4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
				[File]::new("Component5","D:\Program Files\Nice Systems\Logs\Component5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
				)
		}
		elseif ($ParentFolder -match "D:\\Program Files\\Nice Systems\\Logs\\Component.$")
		{
			$childFolders=@(
				[File]::new("Log","$ParentFolder\Log",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
				[File]::new("Archive","$ParentFolder\Log",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null))
				)
		}
		elseif ($ParentFolder -match "D:\\Program Files\\Nice Systems\\Logs\\Component.\\Archive")
		{
			$childFolders=@(
				[File]::new("Name1","$ParentFolder\Name1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
				[File]::new("Name2","$ParentFolder\Name2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
				[File]::new("Name3","$ParentFolder\Name3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
				[File]::new("Name4","$ParentFolder\Name4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
				[File]::new("Name5","$ParentFolder\Name5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)
		}
		else 
		{
			$childFolders=@()
		}
		return $childFolders
    }
}
class BaseFolderChecker
{
	[bool] FolderExists([string]$Path) 
	{
		write-host "Method not implemented" 
		return $false
    }
}

class FolderChecker:BaseFolderChecker
{
	[BaseLogger] $logger

	FolderChecker([BaseLogger]$Logger)
	{
        $this.logger = $Logger
    }
	[bool] FolderExists([string]$Path) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Entering method" )
		return Test-Path -Path "$Path"
	}
}

class BaseArchiveFilter
{
	[File[]] GetOldestFolders([File[]]$Folders) 
	{
		write-host "Method not implemented" 
		return return @()
    }
}

class ArchiveFilter:BaseArchiveFilter
{
	[BaseLogger] $logger

	ArchiveFilter([BaseLogger]$Logger)
	{
        $this.logger = $Logger
    }
	[File[]] GetOldestFolders([File[]]$Folders) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Entering method" )
		if ($Folders.Count -eq 0)
		{
			return @()
		}
		$sortedFolders=$Folders | Sort-Object -Property LastWriteTime -Descending
		$newestFolder=$sortedFolders[0]
		$this.logger.Log( [LogLevel]::Debug, "Newest archive folder is $($newestFolder.Name)" )
				
		return $Folders | Where-Object { $_.Name -ne $newestFolder.Name }
	}
}

class  BaseBackupFolderFactory 
{
    [void] CreateFolder([string]$Path,[string]$FolderName) 
	{
		write-host "Method not implemented" 
    }
}

class BackupFolderFactory:BaseBackupFolderFactory 
{
	[BaseLogger] $logger
	[BaseFolderChecker] $folderChecker

	BackupFolderFactory([BaseLogger]$Logger,[BaseFolderChecker] $FolderChecker)
	{
        $this.logger = $Logger
		$this.folderChecker=$FolderChecker
    }

	[void] CreateFolder([string]$Path,[string]$FolderName) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Entering method" )
		$fullPath=Join-Path $Path $FolderName
		if($this.folderChecker.FolderExists( $fullPath ))
		{
			$this.logger.Log( [LogLevel]::Info, "Backup folder $FolderName already exists in $Path" )
		}
		else 
		{
			$this.logger.Log( [LogLevel]::Info, "Creating backup folder $FolderName in $Path" )
			New-Item -Path $Path -Name $FolderName -ItemType "directory" -Confirm:$false
		}
    }
}
class MockedBackupFolderFactory:BaseBackupFolderFactory 
{
	
	[int] $CreatedCount

	MockedBackupFolderFactory()
	{
        $this.CreatedCount = 0
    }

	[void] CreateFolder([string]$Path,[string]$FolderName) 
	{
		$this.CreatedCount+=1
    }
}

class  BaseFolderMover 
{
    [void] MoveFolder([string]$Source,[string]$Destination) 
	{
		write-host "Method not implemented" 
    }
}

class FolderMover:BaseFolderMover 
{
	[BaseLogger] $logger

	FolderMover([BaseLogger]$Logger)
	{
        $this.logger = $Logger
    }
	
    [void] MoveFolder([string]$Source,[string]$Destination) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Entering method" )
		
		$this.logger.Log( [LogLevel]::Info, "Moving folder $Source to $Destination" )
		Move-Item -Path $Source -Destination $Destination 
    }
}

class MockedFolderMover:BaseFolderMover 
{

	[int] $MovedCount

	FolderMover()
	{
		$this.MovedCount=0
    }
	
    [void] MoveFolder([string]$Source,[string]$Destination) 
	{
		$this.MovedCount += 1
    }
}

class  BaseProcessor
{
	
	[void] ProcessFolder([string]$CurrentFolder,[string]$BackupFolder) 
	{
		write-host "Method not implemented" 
    }
}

class Processor:BaseProcessor 
{
	[string] $archiveFolderName
	[BaseLogger] $logger
	[BaseChildFolderProvider] $childFolderProvider
	[BaseBackupFolderFactory] $backupFolderFactory
	[BaseArchiveProcessor] $archiveProcessor

	Processor([BaseLogger]$Logger,[string] $ArchiveFolderName,[BaseChildFolderProvider] $ChildFolderProvider,[BaseBackupFolderFactory] $BackupFolderFactory,[BaseArchiveProcessor] $ArchiveProcessor)
	{
        $this.logger = $Logger
		$this.archiveFolderName=$ArchiveFolderName
		$this.childFolderProvider=$ChildFolderProvider
		$this.backupFolderFactory=$BackupFolderFactory
		$this.archiveProcessor=$ArchiveProcessor
    }
	
    [void] ProcessFolder([string]$CurrentFolder,[string]$BackupFolder) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Entering method" )
		$childFolders=$this.childFolderProvider.GetChildFolders($CurrentFolder);
		foreach ($childFolder in $childFolders)
		{
			$this.backupFolderFactory.CreateFolder($BackupFolder,$childFolder.Name);

			$newCurrentFolder=Join-Path $CurrentFolder $childFolder.Name
			$newBackupFolder=Join-Path $BackupFolder $childFolder.Name

			if ($childFolder.Name -eq $this.archiveFolderName)
			{
				$this.logger.Log( [LogLevel]::Info, "Found archive folder in $CurrentFolder" )
				$this.archiveProcessor.ProcessArchive($newCurrentFolder,$newBackupFolder)
			}
			else 
			{
				$this.ProcessFolder($newCurrentFolder,$newBackupFolder )
			}
		}
    }
}

class  BaseArchiveProcessor
{
	
	[void] ProcessArchive([string]$CurrentFolder,[string]$BackupFolder) 
	{
		write-host "Method not implemented" 
    }
}

class ArchiveProcessor:BaseArchiveProcessor 
{
	[BaseLogger] $logger
	[BaseChildFolderProvider] $childFolderProvider
	[BaseArchiveFilter] $archiveFilter
	[BaseFolderMover] $folderMover

	ArchiveProcessor([BaseLogger]$Logger,[BaseChildFolderProvider] $ChildFolderProvider,[BaseArchiveFilter] $ArchiveFilter,[BaseFolderMover] $FolderMover)
	{
        $this.logger = $Logger
		$this.childFolderProvider=$ChildFolderProvider
		$this.archiveFilter=$ArchiveFilter
		$this.folderMover=$FolderMover
    }
	
    [void] ProcessArchive([string]$CurrentFolder,[string]$BackupFolder) 
	{
		$this.logger.Log( [LogLevel]::Debug, "Entering method" )
		$this.logger.Log( [LogLevel]::Info, "Filtering oldest archive folders" )
		$childFolders=$this.childFolderProvider.GetChildFolders($CurrentFolder)
		$filteredFolders=$this.archiveFilter.GetOldestFolders($childFolders)
		foreach ($filteredFolder in $filteredFolders)
		{
			$this.folderMover.MoveFolder($filteredFolder.FullName,$BackupFolder)
		}
    }
}




if ($PSBoundParameters.ContainsKey('Debug') -and [bool]$PSBoundParameters.item("Debug"))
{
	$logger=[ScreenLogger]::new()
}
else
{
	$logger=[NullLogger]::new()
}


$folderChecker=[FolderChecker]::new($logger)
$backupFolderFactory=[BackupFolderFactory]::new($logger,$folderChecker)
$childFolderProvider=[ChildFolderProvider]::new($logger)
$archiveFilter=[ArchiveFilter]::new($logger)
$folderMover=[FolderMover]::new($logger)
$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
$processor = [Processor]::new($logger,'Archive',$childFolderProvider,$backupFolderFactory,$archiveProcessor)

$processor.ProcessFolder($NiceLogFolder,$BackupFolder);
