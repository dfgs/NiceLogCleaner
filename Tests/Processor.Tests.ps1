BeforeAll { 
    . $PSScriptRoot/../CleanLogs.ps1
}
Describe 'Processor tests' {
	It 'Processor should move files, zero archive to keep'	{
		$logger=[NullLogger]::new()
		$backupFolderFactory=[MockedBackupFolderFactory]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()
		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		
		$processor = [Processor]::new($logger,'Archive',$childFolderProvider,$backupFolderFactory,$archiveProcessor)
		$processor.ProcessFolder('D:\Program Files\Nice Systems\Logs','d:\Backup\Logs',0)
		$folderMover.MovedCount | Should -Be 25
		$backupFolderFactory.CreatedCount | Should -Be 15
	}	
	It 'Processor should move files, one archive to keep'	{
		$logger=[NullLogger]::new()
		$backupFolderFactory=[MockedBackupFolderFactory]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()
		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		
		$processor = [Processor]::new($logger,'Archive',$childFolderProvider,$backupFolderFactory,$archiveProcessor)
		$processor.ProcessFolder('D:\Program Files\Nice Systems\Logs','d:\Backup\Logs',1)
		$folderMover.MovedCount | Should -Be 20
		$backupFolderFactory.CreatedCount | Should -Be 15
	}
	It 'Processor should move files, two archives to keep'	{
		$logger=[NullLogger]::new()
		$backupFolderFactory=[MockedBackupFolderFactory]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()
		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		
		$processor = [Processor]::new($logger,'Archive',$childFolderProvider,$backupFolderFactory,$archiveProcessor)
		$processor.ProcessFolder('D:\Program Files\Nice Systems\Logs','d:\Backup\Logs',2)
		$folderMover.MovedCount | Should -Be 15
		$backupFolderFactory.CreatedCount | Should -Be 15
	}
	It 'Processor should move files, five archives to keep'	{
		$logger=[NullLogger]::new()
		$backupFolderFactory=[MockedBackupFolderFactory]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()
		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		
		$processor = [Processor]::new($logger,'Archive',$childFolderProvider,$backupFolderFactory,$archiveProcessor)
		$processor.ProcessFolder('D:\Program Files\Nice Systems\Logs','d:\Backup\Logs',5)
		$folderMover.MovedCount | Should -Be 0
		$backupFolderFactory.CreatedCount | Should -Be 15
	}
}