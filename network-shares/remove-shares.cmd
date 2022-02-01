:: (c) Sebastian Resch
:: Setup Network - Shares
@echo OFF
:: Remove Shares
:: LWK => Laufwerk
net share "LWK-IT" /delete
net share "LWK-Handel" /delete
net share "LWK-Produktion" /delete
net share "LWK-Verwaltung" /delete

rmdir C:\Laufwerke /s