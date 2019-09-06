using UnityEngine;
using System.Collections;

public class DissolveWithTransform : MonoBehaviour
{
	public Transform target;


	public float MaxDistance
	{
		get { return _maxDistance; }

		set {
			_maxDistance = value;
			_material.SetFloat("_MaxDistance", _maxDistance);
		}
	}
	[SerializeField]
	private float _maxDistance = 1;

	public float Intensity
	{
		get { return _intensity; }

		set
		{
			_intensity = value;
			_material.SetFloat("_Intensity", _intensity);
		}
	}
	[SerializeField]
	private float _intensity = 1;

	public float DissolveAmount
	{
		get { return _dissolveAmount; }

		set
		{
			_dissolveAmount = value;
			_material.SetFloat("_DissolveAmount", _dissolveAmount);
		}
	}
	[SerializeField]
	private float _dissolveAmount = 1;


	private Material _material;

	void Start ()
	{
		var render = transform.GetComponent<Renderer>();
		if (render != null) {
			_material = render.material;

			MaxDistance = _maxDistance;
			Intensity = _intensity;
			DissolveAmount = _dissolveAmount;
		}
		else {
			enabled = false;
		}
	}

	void Update ()
	{
		if (target == null) {
			return;
		}

		_material.SetVector("_DissolvePoint", target.position);
	}
}