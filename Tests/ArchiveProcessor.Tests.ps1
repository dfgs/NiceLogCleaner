BeforeAll { 
    . $PSScriptRoot/../CleanLogs.ps1
}
Describe 'ArchiveProcessor tests' {
	It 'FolderChecker should find C: path'	{
		$logger=[NullLogger]::new()
		$childFolderProvider=[ChildFolderProvider]::new($logger)
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folderMover=[FolderMover]::new($logger)

		$archiveProcessor = [ArchiveProcessor]::new($logger,$childFolderProvider,$archiveFilter,$folderMover)		
		$folderChecker.FolderExists('c:') | Should -Be $true
	}
	It 'FolderChecker should find C:\Windows path'	{
		$logger=[NullLogger]::new()
		$folderChecker=[FolderChecker]::new($logger)
		$folderChecker.FolderExists('c:\Windows') | Should -Be $true
	}
	It 'FolderChecker should not find Z:\no_exists path'	{
		$logger=[NullLogger]::new()
		$folderChecker=[FolderChecker]::new($logger)
		$folderChecker.FolderExists('Z:\no_exists') | Should -Be $false
	}
}