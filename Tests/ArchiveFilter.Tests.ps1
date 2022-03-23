BeforeAll { 
    . $PSScriptRoot/../CleanLogs.ps1
}
Describe 'ArchiveFilter tests' {
	It 'ArchiveFilter should filter several folders'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name2","FullName2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name3","FullName3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
			[File]::new("Name4","FullName4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
			[File]::new("Name5","FullName5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders);

		$filteredFolders.Count | Should -Be 4
		$filteredFolders[0].Name | Should -Be "Name1"
		$filteredFolders[1].Name | Should -Be "Name2"
		$filteredFolders[2].Name | Should -Be "Name4"
		$filteredFolders[3].Name | Should -Be "Name5"
	}
	It 'ArchiveFilter should filter one folder'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null))
			)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders);

		$filteredFolders.Count | Should -Be 0
	}
	It 'ArchiveFilter should filter zero folder'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(	)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders);

		$filteredFolders.Count | Should -Be 0
	}
}