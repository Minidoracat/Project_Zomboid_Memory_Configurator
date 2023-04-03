# PZ 記憶體配置器

[English version](README.md)

這個小工具目前有以下特點：
- 自動判斷遊戲目錄找到 ProjectZomboid64.json 檔案
- 自動讀取現在記憶體設定
- 自動判斷系統記憶體
- 自動給予建議的記憶體值(你也可以自己輸入)

重點是你什麼都不用安裝，全部都是 windows 內建指令。

未來預計要做的：
- 增加不同的語言給國外的朋友使用
- 加強防呆措施

注意事項：
適用環境：
目前僅在 windows 10 及 windows 11 64 位元版進行測試，也僅適用於 64 位元的系統。
windows 7 能不能順利運作我不清楚，留待有 windows 7 的人替我驗證。
有任何問題都歡迎跟我回報。

使用情境：
1. 當你驗證過遊戲後，記憶體設定就會改回去，因此要重新修改。
2. 當遊戲更新的時候，很有可能會更新 ProjectZomboid64.json 這個檔案。
如果有以上情況，你都可以打開這個小工具，直接看他上面幫你判斷的記憶體設定。

授權：
歡迎轉載分享，但是請註明出處就可以了。

下載方式:
請前往 [Releases 頁面](https://github.com/Minidoracat/Project_Zomboid_Memory_Configurator/releases) 並選擇您想要的語言版本進行下載。

使用教學：
遊戲請先關閉，否則會無法修改檔案。
1. 直接執行 PZ_Memory_Configurator.bat。
2. 會列出你目前系統記憶體、遊戲目錄、目前遊戲設定的記憶體值。
接著你只需要輸入1或2。

3. 如果你選擇2：
那麼就請輸入數字就好，不要有多餘的字，如果不小心輸入錯也沒關係...
重新用 Steam 驗證遊戲就可以了。

後記：
會用 bat 來寫腳本，是為了讓大家都可以方便使用，並且公開源碼，不需安裝任何東西。


[![Discord](https://img.shields.io/badge/Discord-%E8%81%8A%E5%A4%A9%E5%AE%A4-blue?style=flat-square&logo=discord)](https://discord.gg/Gur2V67)

如果您有任何問題或疑慮，歡迎在 GitHub 上開啟一個 issue 或加入我們的 [Discord 伺服器](https://discord.gg/Gur2V67) 尋求幫助。
