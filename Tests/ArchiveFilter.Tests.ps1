BeforeAll { 
    . $PSScriptRoot/../CleanLogs.ps1
}
Describe 'ArchiveFilter tests' {
	It 'ArchiveFilter should filter several folders, zero archive to keep'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name2","FullName2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name3","FullName3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
			[File]::new("Name4","FullName4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
			[File]::new("Name5","FullName5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,0);

		$filteredFolders.Count | Should -Be 5
		$filteredFolders[0].Name | Should -Be "Name3"
		$filteredFolders[1].Name | Should -Be "Name1"
		$filteredFolders[2].Name | Should -Be "Name4"
		$filteredFolders[3].Name | Should -Be "Name5"
		$filteredFolders[4].Name | Should -Be "Name2" 
	}
	It 'ArchiveFilter should filter several folders, one archive to keep'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name2","FullName2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name3","FullName3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
			[File]::new("Name4","FullName4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
			[File]::new("Name5","FullName5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,1);

		$filteredFolders.Count | Should -Be 4
		$filteredFolders[0].Name | Should -Be "Name1"
		$filteredFolders[1].Name | Should -Be "Name4"
		$filteredFolders[2].Name | Should -Be "Name5"
		$filteredFolders[3].Name | Should -Be "Name2" 
	}
	It 'ArchiveFilter should filter several folders, two archives to keep'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name2","FullName2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name3","FullName3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
			[File]::new("Name4","FullName4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
			[File]::new("Name5","FullName5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,2);

		$filteredFolders.Count | Should -Be 3
		$filteredFolders[0].Name | Should -Be "Name4"
		$filteredFolders[1].Name | Should -Be "Name5"
		$filteredFolders[2].Name | Should -Be "Name2" 
	}
	It 'ArchiveFilter should filter several folders, four archives to keep'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name2","FullName2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name3","FullName3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
			[File]::new("Name4","FullName4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
			[File]::new("Name5","FullName5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,4);

		$filteredFolders.Count | Should -Be 1
		$filteredFolders[0].Name | Should -Be "Name2" 
	}
	It 'ArchiveFilter should filter one folder'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null))
			)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,1);

		$filteredFolders.Count | Should -Be 0
	}
	It 'ArchiveFilter should filter zero folder'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(	)
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,1);

		$filteredFolders.Count | Should -Be 0
	}
	It 'ArchiveFilter should filter folders when NumberOfArchiveToKeep is equal to number of archives'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name2","FullName2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name3","FullName3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
			[File]::new("Name4","FullName4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
			[File]::new("Name5","FullName5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)		
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,5);

		$filteredFolders.Count | Should -Be 0
	}
	It 'ArchiveFilter should filter folders when NumberOfArchiveToKeep is greater than number of archives'	{
		$logger=[NullLogger]::new()
		$archiveFilter=[ArchiveFilter]::new($logger)
		$folders=@(
			[File]::new("Name1","FullName1",[datetime]::parseexact('2021-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name2","FullName2",[datetime]::parseexact('2020-12-01', 'yyyy-MM-dd', $null)),
			[File]::new("Name3","FullName3",[datetime]::parseexact('2022-01-15', 'yyyy-MM-dd', $null)),
			[File]::new("Name4","FullName4",[datetime]::parseexact('2021-03-05', 'yyyy-MM-dd', $null)),
			[File]::new("Name5","FullName5",[datetime]::parseexact('2021-02-11', 'yyyy-MM-dd', $null))
			)		
		$filteredFolders=$archiveFilter.GetOldestFolders($folders,15);

		$filteredFolders.Count | Should -Be 0
	}
}