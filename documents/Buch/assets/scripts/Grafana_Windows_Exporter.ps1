# Monitoring
$DownloadURL = "https://github.com/prometheus-community/windows_exporter/releases/download/v0.30.4/windows_exporter-0.30.4-amd64.msi"
Invoke-WebRequest $DownloadURL -OutFile windows_exporter.msi
.\windows_exporter.msi ENABLED_COLLECTORS="ad,adfs,cache,cpu,cpu_info,cs,container,dfsr,dhcp,dns,fsrmquota,iis,logical_disk,logon,memory,msmq,mssql,netframework_clrexceptions,netframework_clrinterop,netframework_clrjit,netframework_clrloading,netframework_clrlocksandthreads,netframework_clrmemory,netframework_clrremoting,netframework_clrsecurity,net,os,process,remote_fx,service,tcp,time,vmware" TEXTFILE_DIR="C:\custom_metrics" LISTEN_PORT="9115" -quiet
New-NetFirewallRule -Name "AllowWindowsExporter" -DisplayName "Allow Windows Exporter on port 9182" -Direction Inbound -Protocol TCP -LocalPort 9182 -Action Allow
