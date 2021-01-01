using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Doors : MonoBehaviour
{
    public void toggle(string data) {
        FlutterUnityPlugin.Message message = FlutterUnityPlugin.Messages.Receive(data);

        // Flutter --> "TrunkDoor,true" --> true == open

        var part = message.data.Split(","[0]);
        bool value = bool.Parse(part[1]);

        switch (part[0])
        {
            case "trunkdoor":
                GameObject trunk = GameObject.Find("TrunkDoor");
                trunk.GetComponent<Animator>().SetBool("opentrunk", value);
                break;
            case "blinds":
                GameObject blinds = GameObject.Find("Blinds");
                blinds.GetComponent<Animator>().SetBool("openblinds", value);
                break;
            case "driverfrontdoor":
                GameObject dfd = GameObject.Find("DriverFrontDoor");
                dfd.GetComponent<Animator>().SetBool("dooropened", value);
                break;
            case "driverreardoor":
                GameObject drd = GameObject.Find("DriverRearDoor");
                drd.GetComponent<Animator>().SetBool("dooropened", value);
                break;
            case "passengerfrontdoor":
                GameObject pfd = GameObject.Find("PassengerFrontDoor");
                pfd.GetComponent<Animator>().SetBool("dooropened", value);
                break;
            case "passengerreardoor":
                GameObject prd = GameObject.Find("PassengerRearDoor");
                prd.GetComponent<Animator>().SetBool("dooropened", value);
                break;
            default: break;
        }
    }
}
