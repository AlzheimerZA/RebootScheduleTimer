<#
.COPYRIGHT
Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#############################################################################
#                                     			 		                    #
#   This Sample Code is provided for the purpose of illustration only       #
#   and is not intended to be used in a production environment.  THIS       #
#   SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT    #
#   WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT    #
#   LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS     #
#   FOR A PARTICULAR PURPOSE.  We grant You a nonexclusive, royalty-free    #
#   right to use and modify the Sample Code and to reproduce and distribute #
#   the object code form of the Sample Code, provided that You agree:       #
#   (i) to not use Our name, logo, or trademarks to market Your software    #
#   product in which the Sample Code is embedded; (ii) to include a valid   #
#   copyright notice on Your software product in which the Sample Code is   #
#   embedded; and (iii) to indemnify, hold harmless, and defend Us and      #
#   Our suppliers from and against any claims or lawsuits, including        #
#   attorneys' fees, that arise or result from the use or distribution      #
#   of the Sample Code.                                                     #
#                                     			 		                    #
#   Author: John Guy                                                        #
#   Version 1.0         Date Last modified:      4 November 2021             #
#                                     			 		                    #
#############################################################################
#>
 
#----------------------------------------------
#region Import Assemblies
#----------------------------------------------
[void][Reflection.Assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
#endregion Import Assemblies
 
#Define a Param block to use custom parameters in the project
#Param ($CustomParameter)
 	#Function to create the task schedule from the time selected from the combobox
	function schedule {
	$time=$combobox1.SelectedItem.ToString() 
	(schtasks /create /sc once /tn "Post Maintenance Restart" /tr "shutdown /r /f" /st $time /f)
                     } 
function Main {

 Param ([String]$Commandline)
 
 #--------------------------------------------------------------------------
 #TODO: Add initialization script here (Load modules and check requirements)
 
 #--------------------------------------------------------------------------
 
 if((Call-MainForm_psf) -eq 'OK')
 {
 
 }
 
 $global:ExitCode = 0 #Set the exit code for the Packager
}
 
#endregion Source: Startup.pss
 
#region Source: MainForm.psf
function Call-MainForm_psf
{
 
 #----------------------------------------------
 #region Import the Assemblies
 #----------------------------------------------
 [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
 [void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
 [void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
 #endregion Import Assemblies
 
 #----------------------------------------------
 #region Generated Form Objects
 #----------------------------------------------
 [System.Windows.Forms.Application]::EnableVisualStyles()
 $MainForm = New-Object 'System.Windows.Forms.Form'
 $panel2 = New-Object 'System.Windows.Forms.Panel'
 $ButtonCancel = New-Object 'System.Windows.Forms.Button'
 $combobox1 = New-Object 'System.Windows.Forms.ComboBox'
 $ButtonRestartNow = New-Object 'System.Windows.Forms.Button'
 $panel1 = New-Object 'System.Windows.Forms.Panel'
 $labelITSystemsMaintenance = New-Object 'System.Windows.Forms.Label'
 $labelSecondsLeftToRestart = New-Object 'System.Windows.Forms.Label'
 $labelTime = New-Object 'System.Windows.Forms.Label'
 $labelInOrderToApplySecuri = New-Object 'System.Windows.Forms.Label'
 $timerUpdate = New-Object 'System.Windows.Forms.Timer'
 $InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
 #endregion Generated Form Objects
 
 #----------------------------------------------
 # User Generated Script
 #----------------------------------------------
 $TotalTime = 900 #in seconds
 $time = Get-Date -format "HH:mm:ss"
 
 $MainForm_Load={
 #TODO: Initialize Form Controls here
 $labelTime.Text = "{0:D2}" -f $TotalTime #$TotalTime
 #Add TotalTime to current time
 $script:StartTime = (Get-Date).AddSeconds($TotalTime)
 #Start the timer
 $timerUpdate.Start()
 }
 
 $timerUpdate_Tick={
 # Define countdown timer
 [TimeSpan]$span = $script:StartTime - (Get-Date)
 #Update the display
 $labelTime.Text = "{0:N0}" -f $span.TotalSeconds
 $timerUpdate.Start()
 if ($span.TotalSeconds -le 0)
 {
 $timerUpdate.Stop()
 Restart-Computer -Force
 }
 
 }
 #region Control Helper Functions
	function Update-ComboBox
	{
		
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			[System.Windows.Forms.ComboBox]
			$ComboBox,
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			$Items,
			[Parameter(Mandatory = $false)]
			[string]$DisplayMember,
			[Parameter(Mandatory = $false)]
			[string]$ValueMember,
			[switch]
			$Append
		)
		
		if (-not $Append)
		{
			$ComboBox.Items.Clear()
		}
		
		if ($Items -is [Object[]])
		{
			$ComboBox.Items.AddRange($Items)
		}
		elseif ($Items -is [System.Collections.IEnumerable])
		{
			$ComboBox.BeginUpdate()
			foreach ($obj in $Items)
			{
				$ComboBox.Items.Add($obj)
			}
			$ComboBox.EndUpdate()
		}
		else
		{
			$ComboBox.Items.Add($Items)
		}
		
		if ($DisplayMember)
		{
			$ComboBox.DisplayMember = $DisplayMember
		}
		
		if ($ValueMember)
		{
			$ComboBox.ValueMember = $ValueMember
		}
	}
	
	
	#endregion
 $ButtonRestartNow_Click = {
 # Restart the computer immediately
 Restart-Computer -Force
 }
 
 $ButtonSchedule_Click={
 # Schedule restart for 6pm

 }
 
 $ButtonCancel_Click={
 #TODO: Place custom script here
	 	schedule
 		$MainForm.Close()
 }
 
 $labelITSystemsMaintenance_Click={
 #TODO: Place custom script here
 
 }
 
 $panel2_Paint=[System.Windows.Forms.PaintEventHandler]{
 #Event Argument: $_ = [System.Windows.Forms.PaintEventArgs]
 #TODO: Place custom script here
 
 }
 
 $labelTime_Click={
 #TODO: Place custom script here
 
 }
 $MainForm.Add_FormClosing({
 [System.Windows.MessageBox]::Show('Your Computer will automatically restart in 5 minutes!','Warning')
 Start-Sleep -Seconds 300 ; Restart-Computer -Force
 })

 # --End User Generated Script--
 #----------------------------------------------
 #region Generated Events
 #----------------------------------------------
 
 $Form_StateCorrection_Load=
 {
 #Correct the initial state of the form to prevent the .Net maximized form issue
 $MainForm.WindowState = $InitialFormWindowState
 }
 
 $Form_StoreValues_Closing=
 {
 #Store the control values
 }
 
 $Form_Cleanup_FormClosed=
 {
 #Remove all event handlers from the controls
 try
 {
 $ButtonCancel.remove_Click($buttonCancel_Click)
 $ButtonSchedule.remove_Click($ButtonSchedule_Click)
 $ButtonRestartNow.remove_Click($ButtonRestartNow_Click)
 $panel2.remove_Paint($panel2_Paint)
 $labelITSystemsMaintenance.remove_Click($labelITSystemsMaintenance_Click)
 $labelTime.remove_Click($labelTime_Click)
 $MainForm.remove_Load($MainForm_Load)
 $timerUpdate.remove_Tick($timerUpdate_Tick)
 $MainForm.remove_Load($Form_StateCorrection_Load)
 $MainForm.remove_Closing($Form_StoreValues_Closing)
 $MainForm.remove_FormClosed($Form_Cleanup_FormClosed)
 }
 catch [Exception]
 { }
 }
 #endregion Generated Events
 
 #----------------------------------------------
 #region Generated Form Code
 #----------------------------------------------
 $MainForm.SuspendLayout()
 $panel2.SuspendLayout()
 $panel1.SuspendLayout()
 #
 # MainForm
 #
 $MainForm.Controls.Add($panel2)
 $MainForm.Controls.Add($panel1)
 $MainForm.Controls.Add($labelSecondsLeftToRestart)
 $MainForm.Controls.Add($labelTime)
 $MainForm.Controls.Add($labelInOrderToApplySecuri)
 $MainForm.AutoScaleDimensions = '6, 13'
 $MainForm.AutoScaleMode = 'Font'
 $MainForm.BackColor = 'White'
 $MainForm.ClientSize = '373, 279'
 $MainForm.MaximizeBox = $False
 $MainForm.MinimizeBox = $False
 $MainForm.Name = 'MainForm'
 $MainForm.ShowIcon = $False
 $MainForm.ShowInTaskbar = $False
 $MainForm.StartPosition = 'CenterScreen'
 $MainForm.Text = 'Systems Maintenance'
 $MainForm.TopMost = $True
 $MainForm.add_Load($MainForm_Load)
 #
 # panel2
 #
 $panel2.Controls.Add($ButtonCancel)
 $panel2.Controls.Add($combobox1)
 $panel2.Controls.Add($ButtonRestartNow)
 $panel2.BackColor = 'ScrollBar'
 $panel2.Location = '0, 205'
 $panel2.Name = 'panel2'
 $panel2.Size = '378, 80'
 $panel2.TabIndex = 9
 $panel2.add_Paint($panel2_Paint)
 #
 # ButtonCancel
 #
 $ButtonCancel.Location = '250, 17'
 $ButtonCancel.Name = 'ButtonCancel'
 $ButtonCancel.Size = '77, 45'
 $ButtonCancel.TabIndex = 7
 $ButtonCancel.Text = 'Schedule'
 $ButtonCancel.UseVisualStyleBackColor = $True
 $ButtonCancel.add_Click($buttonCancel_Click)
 #
#ComboBox1

$i = 1
while ((Get-date).AddHours($i) -lt (get-date -Hour 00 -Minute 00).AddDays(1))
{
$Time = (Get-date).AddHours($i)
#add to combo
	[void]$combobox1.Items.Add("$($time.hour):00")
$i++

} 
	$combobox1.FormattingEnabled = $True	
    $combobox1.Location = New-Object System.Drawing.Point(139, 17)
	$combobox1.Size = New-Object System.Drawing.Size(105, 21)
	$combobox1.TabIndex = 1

 # ButtonRestartNow
 #
 $ButtonRestartNow.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
 $ButtonRestartNow.ForeColor = 'DarkRed'
 $ButtonRestartNow.Location = '42, 17'
 $ButtonRestartNow.Name = 'ButtonRestartNow'
 $ButtonRestartNow.Size = '91, 45'
 $ButtonRestartNow.TabIndex = 0
 $ButtonRestartNow.Text = 'Restart Now'
 $ButtonRestartNow.UseVisualStyleBackColor = $True
 $ButtonRestartNow.add_Click($ButtonRestartNow_Click)
 #
 # panel1
 #
 $panel1.Controls.Add($labelITSystemsMaintenance)
 $panel1.BackColor = '0, 114, 198'
 $panel1.Location = '0, 0'
 $panel1.Name = 'panel1'
 $panel1.Size = '375, 67'
 $panel1.TabIndex = 8
 #
 # labelITSystemsMaintenance
 #
 $labelITSystemsMaintenance.Font = 'Microsoft Sans Serif, 14.25pt'
 $labelITSystemsMaintenance.ForeColor = 'White'
 $labelITSystemsMaintenance.Location = '11, 18'
 $labelITSystemsMaintenance.Name = 'labelITSystemsMaintenance'
 $labelITSystemsMaintenance.Size = '269, 23'
 $labelITSystemsMaintenance.TabIndex = 1
 $labelITSystemsMaintenance.Text = 'IT Systems Maintenance'
 $labelITSystemsMaintenance.TextAlign = 'MiddleLeft'
 $labelITSystemsMaintenance.add_Click($labelITSystemsMaintenance_Click)
 #
 # labelSecondsLeftToRestart
 #
 $labelSecondsLeftToRestart.AutoSize = $True
 $labelSecondsLeftToRestart.Font = 'Microsoft Sans Serif, 9pt, style=Bold'
 $labelSecondsLeftToRestart.Location = '87, 176'
 $labelSecondsLeftToRestart.Name = 'labelSecondsLeftToRestart'
 $labelSecondsLeftToRestart.Size = '155, 15'
 $labelSecondsLeftToRestart.TabIndex = 5
 $labelSecondsLeftToRestart.Text = 'Seconds left to restart :'
 #
 # labelTime
 #
 $labelTime.AutoSize = $True
 $labelTime.Font = 'Microsoft Sans Serif, 9pt, style=Bold'
 $labelTime.ForeColor = '192, 0, 0'
 $labelTime.Location = '237, 176'
 $labelTime.Name = 'labelTime'
 $labelTime.Size = '43, 15'
 $labelTime.TabIndex = 3
 $labelTime.Text = '00:60'
 $labelTime.TextAlign = 'MiddleCenter'
 $labelTime.add_Click($labelTime_Click)
 #
 # labelInOrderToApplySecuri
 #
 $labelInOrderToApplySecuri.Font = 'Microsoft Sans Serif, 9pt'
 $labelInOrderToApplySecuri.Location = '12, 84'
 $labelInOrderToApplySecuri.Name = 'labelInOrderToApplySecuri'
 $labelInOrderToApplySecuri.Size = '350, 83'
 $labelInOrderToApplySecuri.TabIndex = 2
 $labelInOrderToApplySecuri.Text = 'In order to apply security patches and updates for your system, your machine must be restarted. 
 
If you do not wish to restart you computer at this time please schedule a time for the reboot below.'
 #
 # timerUpdate
 #
 $timerUpdate.add_Tick($timerUpdate_Tick)
 $panel1.ResumeLayout()
 $panel2.ResumeLayout()
 $MainForm.ResumeLayout()
 #endregion Generated Form Code
 
 #----------------------------------------------
 
 #Save the initial state of the form
 $InitialFormWindowState = $MainForm.WindowState
 #Init the OnLoad event to correct the initial state of the form
 $MainForm.add_Load($Form_StateCorrection_Load)
 #Clean up the control events
 $MainForm.add_FormClosed($Form_Cleanup_FormClosed)
 #Store the control values when form is closing
 $MainForm.add_Closing($Form_StoreValues_Closing)
 #Show the Form
 return $MainForm.ShowDialog()
 
}
#endregion Source: MainForm.psf
 
#Start the application
Main ($CommandLine)
