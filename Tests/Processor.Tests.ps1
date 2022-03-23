BeforeAll { 
    . $PSScriptRoot/../CleanLogs.ps1
}
Describe 'Processor tests' {
	It 'Processor should move files'	{
		$logger=[NullLogger]::new()
		$backupFolderFactory=[MockedBackupFolderFactory]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()
		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		
		$processor = [Processor]::new($logger,'Archive',$childFolderProvider,$backupFolderFactory,$archiveProcessor)
		$processor.ProcessFolder('D:\Program Files\Nice Systems\Logs','d:\Backup\Logs')
		$folderMover.MovedCount | Should -Be 20
		$backupFolderFactory.CreatedCount | Should -Be 15
	}
	
}