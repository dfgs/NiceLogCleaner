BeforeAll { 
    . $PSScriptRoot/../CleanLogs.ps1
}
Describe 'ArchiveProcessor tests' {
	It 'ArchiveProcessor should move files'	{
		$logger=[NullLogger]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()

		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		$archiveProcessor.ProcessArchive("D:\Program Files\Nice Systems\Logs","D:\Backup\Logs\Component1\Archive")
		$folderMover.MovedCount | Should -Be 4
	}
	
}