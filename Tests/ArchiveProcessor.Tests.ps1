BeforeAll { 
    . $PSScriptRoot/../CleanLogs.ps1
}
Describe 'ArchiveProcessor tests' {
	It 'ArchiveProcessor should move files, zero archive to keep' {
		$logger=[NullLogger]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()

		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		$archiveProcessor.ProcessArchive("D:\Program Files\Nice Systems\Logs","D:\Backup\Logs\Component1\Archive",0)
		$folderMover.MovedCount | Should -Be 5 
	}
	It 'ArchiveProcessor should move files, one archive to keep' {
		$logger=[NullLogger]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()

		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		$archiveProcessor.ProcessArchive("D:\Program Files\Nice Systems\Logs","D:\Backup\Logs\Component1\Archive",1)
		$folderMover.MovedCount | Should -Be 4
	}
	It 'ArchiveProcessor should move files, two archives to keep' {
		$logger=[NullLogger]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()

		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		$archiveProcessor.ProcessArchive("D:\Program Files\Nice Systems\Logs","D:\Backup\Logs\Component1\Archive",2)
		$folderMover.MovedCount | Should -Be 3
	}
	It 'ArchiveProcessor should move files, five archives to keep' {
		$logger=[NullLogger]::new()
		$childFolderProvider=[MockedChildFolderProvider]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[MockedFolderMover]::new()

		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)
		$archiveProcessor.ProcessArchive("D:\Program Files\Nice Systems\Logs","D:\Backup\Logs\Component1\Archive",5)
		$folderMover.MovedCount | Should -Be 0
	}
}