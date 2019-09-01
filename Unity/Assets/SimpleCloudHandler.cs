using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Vuforia;
using UnityEngine.UI;

public class SimpleCloudHandler : MonoBehaviour, ICloudRecoEventHandler 
{
    private CloudRecoBehaviour mCloudRecoBehaviour;
    private bool mIsScanning = false;
    private string mTargetMetadata = "";
    public ImageTargetBehaviour ImageTargetTemplate;
    public TextMesh textMesh;

    // DllImport這個方法相當於是告訴Unity，有一個unityToIOS函數在外部会實現。
    // 使用這個方法必須要導入System.Runtime.InteropServices;
    // [System.Runtime.InteropServices.DllImport("__Internal")]
	// private static extern void unityToIOS (string str);

    public GUISkin customSkin;

    public void OnInitialized(TargetFinder targetFinder) {
        Debug.Log ("Cloud Reco initialized");
    }

    public void OnInitError(TargetFinder.InitState initError) {
        Debug.Log ("Cloud Reco init error " + initError.ToString());
    }

    public void OnUpdateError(TargetFinder.UpdateState updateError) {
        Debug.Log ("Cloud Reco update error " + updateError.ToString());
    }

    public void OnStateChanged(bool scanning) {
        mIsScanning = scanning;
        if (scanning)
        {
            // clear all known trackables
            var tracker = TrackerManager.Instance.GetTracker<ObjectTracker>();
            tracker.TargetFinder.ClearTrackables(false);
        }
    }

    // Here we handle a cloud target recognition event
    public void OnNewSearchResult(TargetFinder.TargetSearchResult targetSearchResult) {
        TargetFinder.CloudRecoSearchResult cloudRecoSearchResult = 
            (TargetFinder.CloudRecoSearchResult)targetSearchResult;
        // do something with the target metadata
        mTargetMetadata = cloudRecoSearchResult.MetaData;
        
        // stop the target finder (i.e. stop scanning the cloud)
        mCloudRecoBehaviour.CloudRecoEnabled = false;
        
        // Build augmentation based on target
        if (ImageTargetTemplate) {
            // enable the new result with the same ImageTargetBehaviour:
            ObjectTracker tracker = TrackerManager.Instance.GetTracker<ObjectTracker>();
            ImageTargetBehaviour imageTargetBehaviour =
                (ImageTargetBehaviour)tracker.TargetFinder.EnableTracking(
            targetSearchResult, ImageTargetTemplate.gameObject);
        }
    }
    
    void OnGUI() {
        textMesh = textMesh.GetComponent<TextMesh>();
        textMesh.text = mTargetMetadata;
        
        string storeName = mTargetMetadata.Substring(0, mTargetMetadata.IndexOf(","));

        GUIStyle myButtonStyle2 = new GUIStyle(GUI.skin.button);
        myButtonStyle2.fontSize = 30;
        
        // // Rect(float x, float y, float width, float height)
        // // 當點擊按鈕後，調用外部方法
        // if (GUI.Button (new Rect (Screen.width/3,Screen.height/6,Screen.width/4,Screen.height/20), "More Details")) {
        //     // Unity調用ios函數，同時傳遞數據
        //     unityToIOS (storeName);
        // }

        if (!mIsScanning) {
            if (GUI.Button(new Rect(Screen.width/3,Screen.height/8,Screen.width/4,Screen.height/20), "Restart Scanning"), myButtonStyle2){
                // Restart TargetFinder
                mCloudRecoBehaviour.CloudRecoEnabled = true;           
            }
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        mCloudRecoBehaviour = GetComponent<CloudRecoBehaviour>();
        if (mCloudRecoBehaviour){
            mCloudRecoBehaviour.RegisterEventHandler(this);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}