diff --git a/csharp/ICT/Petra/Client/MFinance/Gui/AP/UC_Suppliers.ManualCode.cs b/csharp/ICT/Petra/Client/MFinance/Gui/AP/UC_Suppliers.ManualCode.cs
index 27acfa4..edbe7b5 100644
--- a/csharp/ICT/Petra/Client/MFinance/Gui/AP/UC_Suppliers.ManualCode.cs
+++ b/csharp/ICT/Petra/Client/MFinance/Gui/AP/UC_Suppliers.ManualCode.cs
@@ -229,7 +229,7 @@ namespace Ict.Petra.Client.MFinance.Gui.AP
         /// <returns>void</returns>
         private void SearchFinishedCheckThread()
         {
-            TAsyncExecProgressState ThreadStatus;
+            TProgressState ThreadStatus;
 
             // Check whether this thread should still execute
             while (FKeepUpSearchFinishedCheck)
@@ -241,7 +241,7 @@ namespace Ict.Petra.Client.MFinance.Gui.AP
                 {
                     /* The next line of code calls a function on the PetraServer
                      * > causes a bit of data traffic everytime! */
-                    ThreadStatus = FMainForm.SupplierFindObject.AsyncExecProgress.ProgressState;
+                    ThreadStatus = FMainForm.SupplierFindObject.Progress;
                 }
                 catch (NullReferenceException)
                 {
@@ -253,34 +253,32 @@ namespace Ict.Petra.Client.MFinance.Gui.AP
                     throw;
                 }
 
-                switch (ThreadStatus)
+                if (ThreadStatus.JobFinished)
                 {
-                    case TAsyncExecProgressState.Aeps_Finished:
-                        FKeepUpSearchFinishedCheck = false;
+                    FKeepUpSearchFinishedCheck = false;
 
-                        try
+                    try
+                    {
+                        // see also http://stackoverflow.com/questions/6184/how-do-i-make-event-callbacks-into-my-win-forms-thread-safe
+                        if (InvokeRequired)
                         {
-                            // see also http://stackoverflow.com/questions/6184/how-do-i-make-event-callbacks-into-my-win-forms-thread-safe
-                            if (InvokeRequired)
-                            {
-                                Invoke(new SimpleDelegate(FinishThread));
-                            }
-                            else
-                            {
-                                FinishThread();
-                            }
+                            Invoke(new SimpleDelegate(FinishThread));
                         }
-                        catch (ObjectDisposedException)
+                        else
                         {
-                            // Another exception that can be caused when the main screen is closed while running this thread
-                            return;
+                            FinishThread();
                         }
-
-                        break;
-
-                    case TAsyncExecProgressState.Aeps_Stopped:
-                        FKeepUpSearchFinishedCheck = false;
+                    }
+                    catch (ObjectDisposedException)
+                    {
+                        // Another exception that can be caused when the main screen is closed while running this thread
                         return;
+                    }
+                }
+                else if (ThreadStatus.CancelJob)
+                {
+                    FKeepUpSearchFinishedCheck = false;
+                    return;
                 }
 
                 // Loop again while FKeepUpSearchFinishedCheck is true ...
@@ -662,4 +660,4 @@ namespace Ict.Petra.Client.MFinance.Gui.AP
             return false;
         }
     }
-}
\ No newline at end of file
+}
