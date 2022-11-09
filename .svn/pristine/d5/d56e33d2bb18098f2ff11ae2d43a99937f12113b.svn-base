package neos.cmm.kendo;

import java.util.ArrayList;
import java.util.List;

public class KPanelBarItem extends KItemBase{
	private String text;
	private boolean encoded;
	private String imageUrl;
	
	public KPanelBarItem(){
		items = new ArrayList<KItemBase>();
	}
	
	public KPanelBarItem(String seq, String parentSeq, String text, boolean encoded, String imageUrl){
		super.seq = seq;
		super.parentSeq = parentSeq;
		this.text = text;
		this.encoded = encoded;
		this.imageUrl = imageUrl;
		items = new ArrayList<KItemBase>();
	}
	
	public String getText() {
		return text;
	}
	public boolean isEncoded() {
		return encoded;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public List<KItemBase> getItems() {
		return items;
	}
	public void setText(String text) {
		this.text = text;
	}
	public void setEncoded(boolean encoded) {
		this.encoded = encoded;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public void setItems(List<KItemBase> items) {
		this.items = items;
	}
	public String getSeq() {
		return seq;
	}
	public String getParentSeq() {
		return parentSeq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public void setParentSeq(String parentSeq) {
		this.parentSeq = parentSeq;
	}

}
